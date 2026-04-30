/**
 * Vendored from: specification/ai-foundry/data-plane/Foundry/src/agents/models.tsp
 * Foundry version pin: v1 (as of 2025-07-25)
 *
 * Full copy with imports fixed to relative vendored paths.
 */
import "@typespec/http";
import "@typespec/openapi";
import "@typespec/versioning";
import "../responses/models.tsp";
import "../_servicepatterns.tsp";
import "../_common.tsp";

using TypeSpec.Http;
using TypeSpec.OpenAPI;
using TypeSpec.Versioning;

namespace Azure.AI.Projects;

const AllConditionalAgentDefinitionPreviews = #{
  conditional_previews: #[
    AgentDefinitionOptInKeys.hosted_agents_v1_preview,
    AgentDefinitionOptInKeys.container_agents_v1_preview,
    AgentDefinitionOptInKeys.workflow_agents_v1_preview
  ],
};

@extension("x-ms-foundry-meta", AllConditionalAgentDefinitionPreviews)
model CreateAgentVersionRequest {
  ...MetadataPropertyForRequest;

  @doc("A human-readable description of the agent.")
  @maxLength(512)
  description?: string;

  @doc("The agent definition. This can be a workflow, hosted agent, or a simple agent definition.")
  @extension("x-ms-foundry-meta", AllConditionalAgentDefinitionPreviews)
  definition: AgentDefinition;
}

model CreateAgentVersionFromManifestRequest {
  ...MetadataPropertyForRequest;

  @doc("A human-readable description of the agent.")
  @maxLength(512)
  description?: string;

  @doc("The manifest ID to import the agent version from.")
  manifest_id: string;

  @doc("The inputs to the manifest that will result in a fully materialized Agent.")
  parameter_values: Record<unknown>;
}

model CreateAgentFromManifestRequest {
  @doc("""
    The unique name that identifies the agent. Name can be used to retrieve/update/delete the agent.
    - Must start and end with alphanumeric characters,
    - Can contain hyphens in the middle
    - Must not exceed 63 characters.
    """)
  @maxLength(63)
  name: string;

  ...CreateAgentVersionFromManifestRequest;
}

model UpdateAgentFromManifestRequest {
  ...CreateAgentVersionFromManifestRequest;
}

@extension("x-ms-foundry-meta", AllConditionalAgentDefinitionPreviews)
model CreateAgentRequest {
  @doc("""
    The unique name that identifies the agent. Name can be used to retrieve/update/delete the agent.
    - Must start and end with alphanumeric characters,
    - Can contain hyphens in the middle
    - Must not exceed 63 characters.
    """)
  @maxLength(63)
  name: string;

  ...CreateAgentVersionRequest;
}

model UpdateAgentRequest {
  ...CreateAgentVersionRequest;
}

union AgentObjectType {
  agent: "agent",
  agentVersion: "agent.version",
  agentDeleted: "agent.deleted",
  agentVersionDeleted: "agent.version.deleted",
  agentContainer: "agent.container",
}

model AgentObject {
  @doc("The object type, which is always 'agent'.")
  object: AgentObjectType.agent;

  @doc("The unique identifier of the agent.")
  id: string;

  @doc("The name of the agent.")
  @maxLength(63)
  name: string;

  @doc("The latest version of the agent.")
  versions: {
    latest: AgentVersionObject;
  };
}

model AgentVersionObject {
  ...MetadataPropertyForResponse;

  @doc("The object type, which is always 'agent.version'.")
  object: AgentObjectType.agentVersion;

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

  definition: AgentDefinition;

  @removed(Versions.v1)
  @doc("The provisioning status of the agent version.")
  status: AgentVersionStatus = AgentVersionStatus.active;

  @removed(Versions.v1)
  @doc("Error details if the agent version provisioning failed.")
  error?: ApiError;
}

@removed(Versions.v1)
union AgentVersionStatus {
  creating: "creating",
  active: "active",
  failed: "failed",
  deleting: "deleting",
  deleted: "deleted",
}

union AgentProtocol {
  string,
  activity_protocol: "activity_protocol",
  responses: "responses",

  @removed(Versions.v1)
  invocations: "invocations",
}

union AgentKind {
  string,
  prompt: "prompt",
  hosted: "hosted",
  workflow: "workflow",

  @removed(Versions.v1)
  container_app: "container_app",
}

@doc("Configuration for Responsible AI (RAI) content filtering and safety features.")
model RaiConfig {
  @doc("The name of the RAI policy to apply.")
  rai_policy_name: string;
}

@discriminator("kind")
@extension("x-ms-foundry-meta", AllConditionalAgentDefinitionPreviews)
model AgentDefinition {
  kind: AgentKind;

  @doc("Configuration for Responsible AI (RAI) content filtering and safety features.")
  rai_config?: RaiConfig;
}

@doc("The prompt agent definition")
model PromptAgentDefinition extends AgentDefinition {
  kind: AgentKind.prompt;

  @doc("The model deployment to use for this agent.")
  `model`: string;

  @doc("A system (or developer) message inserted into the model's context.")
  instructions?: string | null;

  @doc("""
    What sampling temperature to use, between 0 and 2.
    """)
  @minValue(0)
  @maxValue(2)
  temperature?: float32 | null = 1;

  @doc("""
    An alternative to sampling with temperature, called nucleus sampling.
    """)
  @minValue(0)
  @maxValue(1)
  top_p?: float32 | null = 1;

  reasoning?: OpenAI.Reasoning | null;

  @doc("An array of tools the model may call while generating a response.")
  tools?: OpenAI.Tool[];

  #suppress "@azure-tools/typespec-azure-core/no-unnamed-union" ""
  @doc("How the model should select which tool (or tools) to use.")
  tool_choice?: string | OpenAI.ToolChoiceParam;

  /** Configuration options for a text response from the model. */
  text?: PromptAgentDefinitionTextOptions;

  @doc("Set of structured inputs that can participate in prompt template substitution or tool argument bindings.")
  structured_inputs?: Record<StructuredInputDefinition>;
}

model PromptAgentDefinitionTextOptions {
  format?: OpenAI.TextResponseFormatConfiguration;
}

@doc("The workflow agent definition.")
@extension(
  "x-ms-foundry-meta",
  #{ required_previews: #[AgentDefinitionOptInKeys.workflow_agents_v1_preview] }
)
model WorkflowAgentDefinition extends AgentDefinition {
  kind: AgentKind.workflow;

  @doc("The CSDL YAML definition of the workflow.")
  workflow?: string;
}

@doc("The hosted agent definition.")
@extension(
  "x-ms-foundry-meta",
  #{ required_previews: #[AgentDefinitionOptInKeys.hosted_agents_v1_preview] }
)
model HostedAgentDefinition extends AgentDefinition {
  kind: AgentKind.hosted;

  @doc("An array of tools the hosted agent's model may call.")
  tools?: OpenAI.Tool[];

  @doc("The protocols that the agent supports for ingress communication.")
  container_protocol_versions: ProtocolVersionRecord[];

  @doc("The CPU configuration for the hosted agent.")
  cpu: string;

  @doc("The memory configuration for the hosted agent.")
  memory: string;

  @doc("Environment variables to set in the hosted agent container.")
  environment_variables?: Record<string>;

  @doc("The image ID for the agent, applicable to image-based hosted agents.")
  image?: string;
}

@doc("The container app agent definition.")
@extension(
  "x-ms-foundry-meta",
  #{
    required_previews: #[AgentDefinitionOptInKeys.container_agents_v1_preview],
  }
)
@removed(Versions.v1)
model ContainerAppAgentDefinition extends AgentDefinition {
  kind: AgentKind.container_app;

  @doc("The protocols that the agent supports for ingress communication.")
  container_protocol_versions: ProtocolVersionRecord[];

  @doc("The resource ID of the Azure Container App that hosts this agent.")
  container_app_resource_id: string;

  @doc("The suffix to apply to the app subdomain when sending ingress to the agent.")
  ingress_subdomain_suffix: string;
}

@doc("A record mapping for a single protocol and its version.")
model ProtocolVersionRecord {
  @doc("The protocol type.")
  protocol: AgentProtocol;

  @doc("The version string for the protocol, e.g. 'v0.1.1'.")
  version: string;
}

alias ListAgentQueryParameters = {
  @query
  @doc("Filter agents by kind.")
  kind?: AgentKind;

  ...CommonPageQueryParameters;
};

@doc("A deleted agent Object")
model DeleteAgentResponse {
  @doc("The object type. Always 'agent.deleted'.")
  object: AgentObjectType.agentDeleted;

  @doc("The name of the agent.")
  name: string;

  @doc("Whether the agent was successfully deleted.")
  deleted: boolean;
}

@doc("A deleted agent version Object")
model DeleteAgentVersionResponse {
  @doc("The object type. Always 'agent.version.deleted'.")
  object: AgentObjectType.agentVersionDeleted;

  @doc("The name of the agent.")
  name: string;

  @doc("The version identifier of the agent.")
  version: string;

  @doc("Whether the agent was successfully deleted.")
  deleted: boolean;
}

@doc("An structured input that can participate in prompt template substitutions and tool argument binding.")
model StructuredInputDefinition {
  @doc("A human-readable description of the input.")
  description?: string;

  @doc("The default value for the input if no run-time value is provided.")
  default_value?: unknown;

  @doc("The JSON schema for the structured input (optional).")
  schema?: Record<unknown>;

  @doc("Whether the input property is required when the agent is invoked.")
  required?: boolean = false;
}

model ToolArgumentBinding {
  @doc("The name of the tool to participate in the argument binding.")
  tool_name?: string;

  @doc("The name of the argument within the tool.")
  argument_name: string;
}
