#!/usr/bin/env python3
"""
Install this repo's Kiro powers the way Kiro's own "Import power from a folder"
flow does, but for all powers at once and idempotently. Machine-agnostic:
derives the repo location from this file and the Kiro home from $HOME (or
$KIRO_POWERS_HOME). Safe to re-run.

Replicates the three pieces of state a folder-install writes:
  1. ~/.kiro/powers/registries/user-added.json  (source records; drives the UI)
  2. ~/.kiro/powers/installed.json               (installed list, registryId=user-added)
  3. ~/.kiro/settings/mcp.json -> powers.mcpServers  (namespaced power-<name>-<server>)

It also symlinks each power dir into ~/.kiro/powers/installed/<name> so edits in
this repo apply without reinstalling. Skips cleanly if Kiro isn't present.
"""
import json
import os
import re
import sys

REPO_POWERS = os.path.join(os.path.dirname(os.path.abspath(__file__)), "powers")
KIRO = os.environ.get("KIRO_POWERS_HOME_ROOT", os.path.expanduser("~/.kiro"))


def frontmatter(power_dir):
    txt = open(os.path.join(power_dir, "POWER.md")).read()
    name = re.search(r'^name:\s*"?([^"\n]+)"?', txt, re.M).group(1).strip()
    desc = re.search(r'^description:\s*"?(.+?)"?\s*$', txt, re.M).group(1).strip()
    return name, desc


def main():
    if not os.path.isdir(KIRO):
        print("Kiro not present (%s missing); skipping power install." % KIRO)
        return 0

    powers = sorted(
        d for d in os.listdir(REPO_POWERS)
        if os.path.isfile(os.path.join(REPO_POWERS, d, "POWER.md"))
    )
    if not powers:
        print("No powers found in %s" % REPO_POWERS)
        return 0

    installed_dir = os.path.join(KIRO, "powers", "installed")
    reg_dir = os.path.join(KIRO, "powers", "registries")
    os.makedirs(installed_dir, exist_ok=True)
    os.makedirs(reg_dir, exist_ok=True)

    # 1) user-added registry
    reg = {"powers": []}
    for p in powers:
        pdir = os.path.join(REPO_POWERS, p)
        name, desc = frontmatter(pdir)
        reg["powers"].append(
            {"name": name, "description": desc,
             "source": {"type": "local", "path": pdir}}
        )
    with open(os.path.join(reg_dir, "user-added.json"), "w") as f:
        json.dump(reg, f, indent=2)

    # 2) installed.json (preserve non-local entries; upsert ours as user-added)
    inst_path = os.path.join(KIRO, "powers", "installed.json")
    if os.path.isfile(inst_path):
        inst = json.load(open(inst_path))
    else:
        inst = {"version": "1.0.0", "installedPowers": [], "dismissedAutoInstalls": []}
    by_name = {e["name"]: e for e in inst["installedPowers"]}
    for p in powers:
        by_name[p] = {"name": p, "registryId": "user-added"}
    # keep original order for pre-existing, append new
    order = [e["name"] for e in inst["installedPowers"]]
    for p in powers:
        if p not in order:
            order.append(p)
    inst["installedPowers"] = [by_name[n] for n in order]
    with open(inst_path, "w") as f:
        json.dump(inst, f, indent=2)

    # 3) powers.mcpServers block in settings/mcp.json (strip allowedTools/autoApprove)
    mcp_path = os.path.join(KIRO, "settings", "mcp.json")
    os.makedirs(os.path.dirname(mcp_path), exist_ok=True)
    mcp = json.load(open(mcp_path)) if os.path.isfile(mcp_path) else {"mcpServers": {}}
    power_servers = {}
    for p in powers:
        mj_path = os.path.join(REPO_POWERS, p, "mcp.json")
        if not os.path.isfile(mj_path):
            continue
        for sname, scfg in json.load(open(mj_path)).get("mcpServers", {}).items():
            scfg = {k: v for k, v in scfg.items()
                    if k not in ("allowedTools", "autoApprove")}
            power_servers["power-%s-%s" % (p, sname)] = scfg
    mcp["powers"] = {"mcpServers": power_servers}
    with open(mcp_path, "w") as f:
        json.dump(mcp, f, indent=2)

    # symlink power dirs into installed/ (reads resolve; edits reflect immediately)
    for p in powers:
        link = os.path.join(installed_dir, p)
        target = os.path.join(REPO_POWERS, p)
        if os.path.islink(link):
            if os.readlink(link) != target:
                os.remove(link)
                os.symlink(target, link)
        elif not os.path.exists(link):
            os.symlink(target, link)

    print("Installed %d Kiro powers: %s" % (len(powers), ", ".join(powers)))
    if not os.path.isfile(os.path.expanduser("~/.secrets/kiro-mcp.env")):
        print("  NOTE: ~/.secrets/kiro-mcp.env not found. devices-gitlab and the")
        print("  global builder-mcp/SuperhumanDocs servers need it for auth.")
    print("  Reload the Kiro window (Developer: Reload Window) to pick these up.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
