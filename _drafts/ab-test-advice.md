---
layout: post
title: "Things to think about when coding an A/B test"
date: 2021-02-06
tags: ab-test
---

- This post is about the coding side, not the product side
  - So we're not going to talk about, say, nested/contingent A/B tests

- Granularity - user vs account
  - two halves:
    1. the criteria to decide whether to bucket
    2. whether the experience should be the same across users
  - be careful if your criteria is at the user level, but the effect is at the account level
- Bucketing too early - product analyst won't be happy
  - Good news is you generally can't bucket too late (or when you do, it's obviously wrong)
- Not re-bucketing when it would make sense
- Re-bucketing when it doesn't make sense

- Think about clean up ahead of time. Say one of the variants wins. Now what?
  - With feature flags I think there's a clear answer
  - Not so with A/B test—the whole point of doing an A/B test is you don't know which variant will win
  - Still, I think there tips that can help clean up: prefer duplication over keeping things DRY
