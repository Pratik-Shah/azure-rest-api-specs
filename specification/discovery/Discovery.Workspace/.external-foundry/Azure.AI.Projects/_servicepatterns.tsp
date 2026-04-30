/**
 * Vendored from: specification/ai-foundry/data-plane/Foundry/src/servicepatterns.tsp
 * Foundry version pin: v1 (as of 2025-07-25)
 *
 * TRIMMED: Only pagination models, FoundryTimestamp, feature opt-in keys, and preview header aliases.
 * Removed: All operation templates (FoundryDataPlaneOperation, Job infrastructure, VersionedOperations).
 */
import "@typespec/http";
import "@typespec/versioning";
import "./_service.tsp";

using Azure.ClientGenerator.Core;
using TypeSpec.Http;
using TypeSpec.Versioning;

namespace Azure.AI.Projects;

// ---- Feature opt-in keys & preview headers ----

/** Feature opt-in keys for agent definition operations supporting hosted or workflow agents. */
union AgentDefinitionOptInKeys {
  hosted_agents_v1_preview: "HostedAgents=V1Preview",
  workflow_agents_v1_preview: "WorkflowAgents=V1Preview",

  @removed(Versions.v1)
  container_agents_v1_preview: "ContainerAgents=V1Preview",
}

union FoundryFeaturesOptInKeys {
  evaluations_v1_preview: "Evaluations=V1Preview",
  schedules_v1_preview: "Schedules=V1Preview",
  red_teams_v1_preview: "RedTeams=V1Preview",
  insights_v1_preview: "Insights=V1Preview",
  memory_stores_v1_preview: "MemoryStores=V1Preview",
}

alias WithConditionalFoundryPreviewHeader<OptionalPreviewOptInHeader extends FoundryFeaturesOptInKeys | AgentDefinitionOptInKeys> = {
  /**
   * A feature flag opt-in required when using preview operations or modifying persisted preview resources.
   */
  @header("Foundry-Features")
  foundry_features?: OptionalPreviewOptInHeader;
};

// ============================================================================
// Pagination
// ============================================================================

@doc("The response data for a requested list of items.")
model AgentsPagedResult<T> {
  /** The requested list of items. */
  @pageItems
  data: T[];

  /** The first ID represented in this list. */
  first_id?: string;

  /** The last ID represented in this list. */
  @continuationToken
  last_id?: string;

  /** A value indicating whether there are additional values available not captured in this list. */
  has_more: boolean;
}

alias PageLimitQueryParameter = {
  /**
   * A limit on the number of objects to be returned. Limit can range between 1 and 100, and the
   * default is 20.
   */
  @query limit?: int32 = 20;
};

union PageOrder {
  "asc",
  "desc",
}

alias PageOrderQueryParameter = {
  /**
   * Sort order by the `created_at` timestamp of the objects. `asc` for ascending order and`desc`
   * for descending order.
   */
  @query order?: PageOrder;
};

alias PageAfterQueryParameter = {
  /**
   * A cursor for use in pagination. `after` is an object ID that defines your place in the list.
   * For instance, if you make a list request and receive 100 objects, ending with obj_foo, your
   * subsequent call can include after=obj_foo in order to fetch the next page of the list.
   */
  @query @continuationToken after?: string;
};

alias PageBeforeQueryParameter = {
  /**
   * A cursor for use in pagination. `before` is an object ID that defines your place in the list.
   * For instance, if you make a list request and receive 100 objects, ending with obj_foo, your
   * subsequent call can include before=obj_foo in order to fetch the previous page of the list.
   */
  @query before?: string;
};

alias CommonPageQueryParameters = {
  ...PageLimitQueryParameter;
  ...PageOrderQueryParameter;
  ...PageAfterQueryParameter;
  ...PageBeforeQueryParameter;
};

// ============================================================================
// Shared Types
// ============================================================================

@encode(DateTimeKnownEncoding.unixTimestamp, int32)
scalar FoundryTimestamp extends utcDateTime;
