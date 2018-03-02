#!/bin/bash
git remote prune origin && comm -23 <(git branch | cut -c 3- | sort) <(git branch -r | cut -c 10- | sort);
