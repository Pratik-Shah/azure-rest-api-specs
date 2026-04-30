# Vendored Foundry Types (Azure.AI.Projects)

## Purpose

These TypeSpec files are selectively vendored from the Azure AI Foundry specification
(`specification/ai-foundry/data-plane/Foundry/src/`) to provide agent and response
API types for the Discovery service's GA version (`2026-06-01`).

## Version Pin

- **Source**: `specification/ai-foundry/data-plane/Foundry/src/`
- **Foundry API version**: v1
- **Vendored date**: 2025-07-25
- **Commit**: (record the commit SHA when finalizing)

## What's Included

| File | Source | Notes |
|------|--------|-------|
| `_service.tsp` | `common/service.tsp` | Trimmed: namespace + Versions enum only |
| `_custom-types.tsp` | `common/custom-types.tsp` | As-is |
| `_common.tsp` | `common/models.tsp` | Trimmed: MetadataProperty, ApiError, OpenAIOperation |
| `_servicepatterns.tsp` | `servicepatterns.tsp` | Trimmed: pagination, FoundryTimestamp, opt-in keys |
| `tools/models.tsp` | `tools/models.tsp` | Trimmed: removed memory-stores import, inlined MemorySearchOptions/Item |
| `responses/models.tsp` | `openai-responses/models.tsp` | Full copy, includes openai-conversations alias |
| `agents/models.tsp` | `agents/models.tsp` | Full copy |

## What's Excluded

- Operation templates (job infrastructure, versioned CRUD interfaces)
- `@service`, `@server`, `@useAuth` decorators (Discovery has its own)
- Memory store operations (only inlined the 2 models needed by tools)
- Container log streaming types

## How to Update

1. Compare current Foundry source with vendored files
2. Apply relevant changes (new models, property additions)
3. Run `tsp compile .` from `Discovery.Workspace/` to verify
4. Update the version pin date and commit above

## Cross-Namespace Versioning

Discovery's `versions.tsp` uses `@useDependency(Azure.AI.Projects.Versions.v1)`
on the `2026-06-01` version member. This tells TypeSpec to project vendored types
at the Foundry v1 version when compiling for Discovery GA.
