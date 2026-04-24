import "@typespec/rest";
import "@typespec/versioning";
import "@azure-tools/typespec-azure-core";
import "./common.tsp";
import "./_project.tsp";

using TypeSpec.Http;
using TypeSpec.Rest;
using TypeSpec.Versioning;
using Azure.Core;
using Azure.Core.Traits;

using Microsoft.Discovery.Common;

@versioned(Microsoft.Discovery.Workspace.Versions)
namespace Microsoft.Discovery.Workspace;

// NOTE: These APIs are actually what the service exposes, but we need to collaborate with the API
// specs owners and SDK archboard to determine the ideal way to consume these models. For now, they will
// be excluded from our specs and SDKs, but still exposed by the service.

/*
@doc("Common properties for Discovery agents.")
@added(Versions.`2026-02-01-preview`)
model AgentBase {
  @doc("Array of tools configured for this agent.")
  @visibility(Lifecycle.Read, Lifecycle.Create)
  tools?: ToolReference[];

  @doc("Array of knowledge bases attached to this agent.")
  @visibility(Lifecycle.Read, Lifecycle.Create)
  knowledgeBases?: KnowledgeBaseReference[];

  @doc("Whether to add a human in the loop tool which the agent can use to request user input.")
  @visibility(Lifecycle.Read, Lifecycle.Create)
  humanInTheLoop?: ConfirmationState;

  #suppress "@azure-tools/typespec-azure-core/bad-record-type" "Need flexible content to match various use-cases"
  @doc("Discovery-specific extensions for the agent.")
  @visibility(Lifecycle.Read, Lifecycle.Create)
  discoveryExtensions?: Record<unknown>;
}

@doc("Foundry agent creation request without name (name is provided at Discovery agent level).")
@added(Versions.`2026-02-01-preview`)
model FoundryAgentCreateRequest {
  ...CreateAgentVersionRequest;
}

@doc("Input model for creating or updating a Discovery agent.")
@added(Versions.`2026-02-01-preview`)
model AgentCreateOrUpdate {
  @doc("The agent name.")
  @maxLength(24)
  @pattern(resourceNamePattern)
  name: string;

  ...AgentBase;

  @doc("Foundry agent creation request (pass-through to Foundry).")
  @visibility(Lifecycle.Create)
  foundryDetails: FoundryAgentCreateRequest;
}

@doc("A Microsoft Discovery AI agent.")
@resource("agents")
@parentResource(Project)
@added(Versions.`2026-02-01-preview`)
model Agent {
  @doc("The agent name.")
  @key("agentName")
  @visibility(Lifecycle.Read)
  @maxLength(24)
  @pattern(resourceNamePattern)
  name: string;

  @doc("Provisioning state of the agent.")
  @visibility(Lifecycle.Read)
  provisioningState?: ProvisioningState;

  ...DataPlaneResource;
  ...AgentBase;

  @doc("Foundry agent object (returned from Foundry).")
  @visibility(Lifecycle.Read)
  foundryDetails?: AgentObject;

  @doc("URI to the agent in Foundry Agent Studio.")
  @visibility(Lifecycle.Read)
  foundryAgentStudioUri?: url;
}

@doc("Confirmation state for tool execution.")
@added(Versions.`2026-02-01-preview`)
union ConfirmationState {
  // Confirmation is enabled
  Enabled: "Enabled",

  // Confirmation is disabled
  Disabled: "Disabled",

  string,
}

@doc("Tool reference")
@added(Versions.`2026-02-01-preview`)
model ToolReference {
  @doc("The resource ID of the tool.")
  toolId: ToolId;

  @doc("Whether user confirmation is required before tool execution.")
  confirmation?: ConfirmationState;
}

@doc("KnowledgeBase reference")
@added(Versions.`2026-02-01-preview`)
model KnowledgeBaseReference {
  @doc("The resource ID of the knowledge base.")
  knowledgeBaseId: string;
}

// ============================================================================
// Agents Interface
// ============================================================================

@added(Versions.`2026-02-01-preview`)
interface Agents {
  @doc("Get a discovery agent by name.")
  getAgent is ResourceRead<Agent>;

  @doc("Get the status of a long-running operation.")
  getOperationStatus is Operations.GetResourceOperationStatus<Agent>;

  @doc("Create or update a discovery agent.")
  @pollingOperation(Agents.getOperationStatus)
  upsertAgent is Operations.LongRunningResourceAction<
    Project,
    AgentCreateOrUpdate,
    Agent
  >;

  @doc("Delete a discovery agent.")
  @pollingOperation(Agents.getOperationStatus)
  deleteAgent is LongRunningResourceDelete<Agent>;

  @doc("List discovery agents in a project.")
  listAgents is ResourceList<Agent>;
}
*/

// ============================================================================
// Discovery v1 Agent API (2026-06-01) — based on Foundry v1
// ============================================================================

@doc("Common properties for Discovery agents.")
@added(Versions.`2026-06-01`)
model DiscoveryAgentBase {
  @doc("Array of tools configured for this agent.")
  @visibility(Lifecycle.Read, Lifecycle.Create)
  tools?: DiscoveryToolReference[];

  @doc("Array of knowledge bases attached to this agent.")
  @visibility(Lifecycle.Read, Lifecycle.Create)
  knowledgeBases?: DiscoveryKnowledgeBaseReference[];

  @doc("Whether to add a human in the loop tool which the agent can use to request user input.")
  @visibility(Lifecycle.Read, Lifecycle.Create)
  humanInTheLoop?: DiscoveryConfirmationState;

  #suppress "@azure-tools/typespec-azure-core/bad-record-type" "Need flexible content to match various use-cases"
  @doc("Discovery-specific extensions for the agent.")
  @visibility(Lifecycle.Read, Lifecycle.Create)
  discoveryExtensions?: Record<unknown>;
}

@doc("Input model for creating or updating a Discovery agent (v1).")
@added(Versions.`2026-06-01`)
model DiscoveryAgentCreateOrUpdate {
  @doc("The agent name.")
  @maxLength(24)
  @pattern(resourceNamePattern)
  name: string;

  ...DiscoveryAgentBase;

  @doc("Foundry agent creation request (pass-through to Foundry v1).")
  @visibility(Lifecycle.Create)
  foundryDetails: FoundryCreateAgentVersionRequest;
}

@doc("A Microsoft Discovery AI agent (v1).")
@resource("agents")
@parentResource(Project)
@added(Versions.`2026-06-01`)
model DiscoveryAgent {
  @doc("The agent name.")
  @key("agentName")
  @visibility(Lifecycle.Read)
  @maxLength(24)
  @pattern(resourceNamePattern)
  name: string;

  @doc("Provisioning state of the agent.")
  @visibility(Lifecycle.Read)
  provisioningState?: ProvisioningState;

  ...DataPlaneResource;
  ...DiscoveryAgentBase;

  @doc("Foundry agent object (returned from Foundry v1).")
  @visibility(Lifecycle.Read)
  foundryDetails?: FoundryAgentObject;

  @doc("URI to the agent in Foundry Agent Studio.")
  @visibility(Lifecycle.Read)
  foundryAgentStudioUri?: url;
}

@doc("Confirmation state for tool execution.")
@added(Versions.`2026-06-01`)
union DiscoveryConfirmationState {
  /** Confirmation is enabled */
  Enabled: "Enabled",

  /** Confirmation is disabled */
  Disabled: "Disabled",

  string,
}

@doc("Tool reference.")
@added(Versions.`2026-06-01`)
model DiscoveryToolReference {
  @doc("The resource ID of the tool.")
  toolId: ToolId;

  @doc("The display name of the tool.")
  name?: string;

  @doc("Whether user confirmation is required before tool execution.")
  confirmation?: DiscoveryConfirmationState;
}

@doc("KnowledgeBase reference.")
@added(Versions.`2026-06-01`)
model DiscoveryKnowledgeBaseReference {
  @doc("The resource ID of the knowledge base.")
  knowledgeBaseId: string;

  @doc("The display name of the knowledge base.")
  name?: string;
}

// ============================================================================
// Feature opt-in header (mirrors Foundry's Foundry-Features pattern)
// ============================================================================

@doc("Feature opt-in keys for agent definition operations supporting hosted agents.")
@added(Versions.`2026-06-01`)
union DiscoveryAgentDefinitionOptInKeys {
  string,

  @doc("Opt-in for hosted agents preview features.")
  hosted_agents_v1_preview: "HostedAgents=V1Preview",
}

// ============================================================================
// v1 Agents Interface
// ============================================================================

@added(Versions.`2026-06-01`)
interface DiscoveryAgents {
  @doc("Get a discovery agent by name.")
  getAgent is ResourceRead<DiscoveryAgent>;

  @doc("Get the status of a long-running operation.")
  getOperationStatus is Operations.GetResourceOperationStatus<DiscoveryAgent>;

  @doc("Create or update a discovery agent.")
  @pollingOperation(DiscoveryAgents.getOperationStatus)
  upsertAgent is Operations.LongRunningResourceAction<
    Project,
    DiscoveryAgentCreateOrUpdate & FoundryFeaturesHeader,
    DiscoveryAgent
  >;

  @doc("Delete a discovery agent.")
  @pollingOperation(DiscoveryAgents.getOperationStatus)
  deleteAgent is LongRunningResourceDelete<DiscoveryAgent>;

  @doc("List discovery agents in a project.")
  listAgents is ResourceList<DiscoveryAgent>;
}

@doc("Optional Foundry-Features header for preview feature opt-in.")
@added(Versions.`2026-06-01`)
model FoundryFeaturesHeader {
  @doc("A feature flag opt-in required when using preview agent definitions such as hosted agents.")
  @header("Foundry-Features")
  foundryFeatures?: DiscoveryAgentDefinitionOptInKeys;
}
