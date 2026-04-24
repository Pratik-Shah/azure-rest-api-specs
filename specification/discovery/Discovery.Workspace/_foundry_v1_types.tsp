/**
 * Vendored Foundry v1 types for Discovery 2026-06-01 integration.
 *
 * These types are sourced from Azure.AI.Projects (Foundry) v1 specification.
 * They are vendored here to avoid cross-project TypeSpec import issues since
 * Foundry is not published as a TypeSpec package.
 *
 * Source: specification/ai-foundry/data-plane/Foundry/src/
 * Baseline: Foundry v1 (as of 2026-04-23)
 */
import "@typespec/rest";
import "@typespec/versioning";
import "@typespec/openapi";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-core/experimental";
import "./versions.tsp";

using TypeSpec.Http;
using TypeSpec.Rest;
using TypeSpec.Versioning;
using TypeSpec.OpenAPI;
using Azure.Core.Experimental;

@versioned(Microsoft.Discovery.Workspace.Versions)
namespace Microsoft.Discovery.Workspace;

// ============================================================================
// Foundry v1 Pagination
// ============================================================================

@doc("The response data for a requested list of items.")
@added(Versions.`2026-06-01`)
model FoundryPagedResult<T> {
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

/** Pagination query parameters matching Foundry v1 conventions. */
@added(Versions.`2026-06-01`)
model FoundryPageQueryParams {
  /** A limit on the number of objects to be returned. Limit can range between 1 and 100, and the default is 20. */
  @query limit?: int32 = 20;

  /** Sort order by the created_at timestamp of the objects. asc for ascending order and desc for descending order. */
  @query order?: FoundryPageOrder;

  /** A cursor for use in pagination. after is an object ID that defines your place in the list. */
  @query @continuationToken after?: string;

  /** A cursor for use in pagination. before is an object ID that defines your place in the list. */
  @query before?: string;
}

@added(Versions.`2026-06-01`)
union FoundryPageOrder {
  "asc",
  "desc",
}

// ============================================================================
// Foundry v1 Agent Reference (used on Response objects)
// ============================================================================

/** An agent reference used on Response and OutputItem objects in Foundry v1. */
@added(Versions.`2026-06-01`)
model FoundryAgentReference {
  /** The type discriminator. Always "agent_reference". */
  type: "agent_reference";

  /** The name of the agent. */
  @maxLength(256)
  name: string;

  /** The version identifier of the agent. Optional in v1 (was required in preview as AgentId). */
  version?: string;
}

// ============================================================================
// Foundry v1 Response Extensions (@@copyProperties on OpenAI types)
// ============================================================================

/** Azure-specific fields for creating a Response (Foundry v1). */
@added(Versions.`2026-06-01`)
model FoundryCreateResponseOptions {
  /** The agent to use for generating the response. */
  agent_reference?: FoundryAgentReference;

  /** The structured inputs to the response that can participate in prompt template substitution or tool argument bindings. */
  structured_inputs?: Record<unknown>;
}

/** Azure-specific fields returned on a Response object (Foundry v1). */
@added(Versions.`2026-06-01`)
model FoundryResponseDetails {
  /** The agent used for this response. */
  agent_reference: FoundryAgentReference | null;
}

// ============================================================================
// Foundry v1 Item Type Extensions
// ============================================================================

/** Extended item types added by Foundry v1 to OpenAI's base item type unions. */
@added(Versions.`2026-06-01`)
union FoundryItemType {
  structured_outputs: "structured_outputs",
  oauth_consent_request: "oauth_consent_request",
  memory_search_call: "memory_search_call",
  workflow_action: "workflow_action",
  a2a_preview_call: "a2a_preview_call",
  a2a_preview_call_output: "a2a_preview_call_output",
  bing_grounding_call: "bing_grounding_call",
  bing_grounding_call_output: "bing_grounding_call_output",
  sharepoint_grounding_preview_call: "sharepoint_grounding_preview_call",
  sharepoint_grounding_preview_call_output: "sharepoint_grounding_preview_call_output",
  azure_ai_search_call: "azure_ai_search_call",
  azure_ai_search_call_output: "azure_ai_search_call_output",
  bing_custom_search_preview_call: "bing_custom_search_preview_call",
  bing_custom_search_preview_call_output: "bing_custom_search_preview_call_output",
  openapi_call: "openapi_call",
  openapi_call_output: "openapi_call_output",
  browser_automation_preview_call: "browser_automation_preview_call",
  browser_automation_preview_call_output: "browser_automation_preview_call_output",
  fabric_dataagent_preview_call: "fabric_dataagent_preview_call",
  fabric_dataagent_preview_call_output: "fabric_dataagent_preview_call_output",
  azure_function_call: "azure_function_call",
  azure_function_call_output: "azure_function_call_output",
}

// ============================================================================
// ============================================================================
// Foundry v1 Compact Response
// ============================================================================

@doc("Request body for compacting a response conversation.")
@added(Versions.`2026-06-01`)
model CompactResponseBody {
  @doc("Model deployment to use for compaction.")
  `model`: string;

  @doc("The response ID of the conversation to compact from.")
  previous_response_id: string;
}

@doc("Result of a compact operation.")
@added(Versions.`2026-06-01`)
model CompactResource {
  @doc("The compacted response ID.")
  id: string;
}

// ============================================================================
// Apply Foundry v1 extensions to OpenAI types via @@copyProperties
// ============================================================================

// Extend OpenAI.CreateResponse with Foundry v1 fields
#suppress "@azure-tools/typespec-azure-core/experimental-feature" "Using experimental copyProperties for Foundry v1 extensions"
@@copyProperties(OpenAI.CreateResponse,
  {
    /** The agent to use for generating the response (Foundry v1). */
    @added(Versions.`2026-06-01`)
    agent_reference?: FoundryAgentReference,

    /** Structured inputs for prompt template substitution or tool argument bindings. */
    @added(Versions.`2026-06-01`)
    structured_inputs?: Record<unknown>,
  }
);

// Extend OpenAI.Response with Foundry v1 fields
#suppress "@azure-tools/typespec-azure-core/experimental-feature" "Using experimental copyProperties for Foundry v1 extensions"
@@copyProperties(OpenAI.Response,
  {
    /** The agent used for this response (Foundry v1). */
    @added(Versions.`2026-06-01`)
    agent_reference: FoundryAgentReference | null,
  }
);

// Extend OpenAI.OutputItem with Foundry v1 fields
#suppress "@azure-tools/typespec-azure-core/experimental-feature" "Using experimental copyProperties for Foundry v1 extensions"
@@copyProperties(OpenAI.OutputItem,
  {
    @doc("The agent that created the item.")
    @added(Versions.`2026-06-01`)
    agent_reference?: FoundryAgentReference,

    @doc("The response on which the item is created.")
    @added(Versions.`2026-06-01`)
    response_id?: string,
  }
);

// Extend item type unions with Foundry v1 types
#suppress "@azure-tools/typespec-azure-core/experimental-feature" "Using experimental copyVariants for Foundry v1 item types"
@@copyVariants(OpenAI.ItemType, FoundryItemType);

#suppress "@azure-tools/typespec-azure-core/experimental-feature" "Using experimental copyVariants for Foundry v1 item types"
@@copyVariants(OpenAI.OutputItemType, FoundryItemType);

// ============================================================================
// Foundry v1 Agent Models (for Discovery Agent wrapper)
// ============================================================================

@encode(DateTimeKnownEncoding.unixTimestamp, int32)
@added(Versions.`2026-06-01`)
scalar FoundryTimestamp extends utcDateTime;

@added(Versions.`2026-06-01`)
union FoundryAgentObjectType {
  agent: "agent",
  agentVersion: "agent.version",
  agentDeleted: "agent.deleted",
  agentVersionDeleted: "agent.version.deleted",
}

@added(Versions.`2026-06-01`)
union FoundryAgentKind {
  string,
  prompt: "prompt",
  hosted: "hosted",
  workflow: "workflow",
}

@added(Versions.`2026-06-01`)
union FoundryAgentProtocol {
  string,
  activity_protocol: "activity_protocol",
  responses: "responses",
}

/** Foundry agent version object (v1 shape — no status/error fields). */
@added(Versions.`2026-06-01`)
model FoundryAgentVersionObject {
  /** Set of 16 key-value pairs that can be attached to an object. */
  @extension("x-oaiTypeLabel", "map")
  metadata: Record<string> | null;

  @doc("The object type, which is always 'agent.version'.")
  object: FoundryAgentObjectType.agentVersion;

  @doc("The unique identifier of the agent version.")
  id: string;

  @doc("The name of the agent.")
  @maxLength(256)
  name: string;

  @doc("The version identifier of the agent.")
  version: string;

  @doc("A human-readable description of the agent.")
  @maxLength(512)
  description?: string;

  @doc("The Unix timestamp (seconds) when the agent was created.")
  created_at: FoundryTimestamp;

  @doc("The agent definition.")
  definition: FoundryAgentDefinition;
}

/** Foundry agent object (v1 shape). */
@added(Versions.`2026-06-01`)
model FoundryAgentObject {
  @doc("The object type, which is always 'agent'.")
  object: FoundryAgentObjectType.agent;

  @doc("The unique identifier of the agent.")
  id: string;

  @doc("The name of the agent.")
  @maxLength(63)
  name: string;

  @doc("The latest version of the agent.")
  versions: {
    latest: FoundryAgentVersionObject;
  };
}

/** Configuration for Responsible AI (RAI) content filtering. */
@added(Versions.`2026-06-01`)
model FoundryRaiConfig {
  @doc("The name of the RAI policy to apply.")
  rai_policy_name: string;
}

/** Base agent definition (Foundry v1). Discriminated by kind. */
@discriminator("kind")
@added(Versions.`2026-06-01`)
model FoundryAgentDefinition {
  kind: FoundryAgentKind;

  @doc("Configuration for Responsible AI (RAI) content filtering.")
  rai_config?: FoundryRaiConfig;
}

/** Prompt agent definition (Foundry v1). */
@added(Versions.`2026-06-01`)
model FoundryPromptAgentDefinition extends FoundryAgentDefinition {
  kind: FoundryAgentKind.prompt;

  @doc("The model deployment to use for this agent.")
  `model`: string;

  @doc("A system (or developer) message inserted into the model's context.")
  instructions?: string | null;

  @doc("Temperature sampling parameter (0-2).")
  @minValue(0)
  @maxValue(2)
  temperature?: float32 | null = 1;

  @doc("Nucleus sampling parameter (0-1).")
  @minValue(0)
  @maxValue(1)
  top_p?: float32 | null = 1;

  @doc("Array of tools the model may call.")
  tools?: OpenAI.Tool[];

  #suppress "@azure-tools/typespec-azure-core/no-unnamed-union" ""
  @doc("How the model should select which tool to use.")
  tool_choice?: string | OpenAI.ToolChoiceParam;
}

/** Request body for creating an agent version (Foundry v1). */
@added(Versions.`2026-06-01`)
model FoundryCreateAgentVersionRequest {
  /** Set of key-value metadata pairs. */
  @extension("x-oaiTypeLabel", "map")
  metadata?: Record<string>;

  @doc("A human-readable description of the agent.")
  @maxLength(512)
  description?: string;

  @doc("The agent definition.")
  definition: FoundryAgentDefinition;
}

/** Deleted agent response (Foundry v1). */
@added(Versions.`2026-06-01`)
model FoundryDeleteAgentResponse {
  @doc("The object type. Always 'agent.deleted'.")
  object: FoundryAgentObjectType.agentDeleted;

  @doc("The name of the agent.")
  name: string;

  @doc("Whether the agent was successfully deleted.")
  deleted: boolean;
}

// ============================================================================
// Foundry v1 Error Model
// ============================================================================

/** Error response for API failures (Foundry v1 pattern). */
@added(Versions.`2026-06-01`)
@error
model FoundryApiErrorResponse {
  error: FoundryApiError;
}

@added(Versions.`2026-06-01`)
model FoundryApiError {
  @doc("The error code.")
  code: string;

  @doc("The error message.")
  message: string;

  @doc("The error target.")
  target?: string;

  @doc("Additional error details.")
  details?: FoundryApiError[];
}

// ============================================================================
// Foundry v1 OpenAI-style Operation Template (no api-version)
// ============================================================================

#suppress "@azure-tools/typespec-azure-core/operation-missing-api-version" "OpenAI-based operations are not conventionally versioned"
#suppress "@azure-tools/typespec-azure-core/use-standard-operations" "OpenAI-based operations are definitionally non-standard"
@added(Versions.`2026-06-01`)
op FoundryOpenAIOperation<
  Params extends Reflection.Model,
  Response,
  ErrorResponse = FoundryApiErrorResponse
>(...Params): Response | ErrorResponse;
