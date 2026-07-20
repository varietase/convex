## Summary
<!-- One paragraph: what changed and why. Reference TASK-### if applicable. -->

## Type
<!-- Check one -->
- [ ] Task implementation (code/docs tied to a TASK-###)
- [ ] Architecture/deployment pivot
- [ ] Decision/pivot reconciliation
- [ ] Bug fix
- [ ] Other: ___

## Reconciliation checklist
<!-- Delete this section if no architecture, deployment, or decision change. -->
- [ ] Decision Ledger `docs/DECISION-LEDGER.md` §3 entry added (if this is a pivot/decision)
- [ ] `docs/system-design.md` updated (if architecture/deployment changed)
- [ ] `docs/prd.md` updated (if product behavior or baseline changed)
- [ ] `docs/ops.md` updated (if deployment runbook changed)
- [ ] `docs/pitch-kit.md` updated (if the demo script references changed infra)
- [ ] `README.md` updated (if architecture description changed)
- [ ] Other affected docs reconciled (api-spec, release-gtm, technical-design, onboarding)
- [ ] Plan checker passes: `./check-plan.sh` or `python3 fmd/tools/check-implementation-plan.py docs/implementation-plan.md --strict`

## Validation
<!-- Exact commands run and their results. -->
```
<paste output here>
```

## Docs impact
<!-- `none` is valid if implementing an unchanged spec. -->
