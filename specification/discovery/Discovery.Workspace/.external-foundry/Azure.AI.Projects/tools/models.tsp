/**
 * Vendored from: specification/ai-foundry/data-plane/Foundry/src/tools/models.tsp
 * Foundry version pin: v1 (as of 2025-07-25)
 *
 * TRIMMED: Removed memory-stores import. Inlined MemorySearchOptions and MemorySearchItem.
 * Full tool type definitions, tool call output models, and @@copyVariants/@@copyProperties retained.
 */
import "@azure-tools/typespec-azure-core/experimental";
import "@typespec/versioning";
import "../_service.tsp";

using Azure.Core.Experimental;
using TypeSpec.Versioning;

#suppress "@azure-tools/typespec-azure-core/experimental-feature" "Using experimental feature"
namespace Azure.AI.Projects {
  //
  // Tool inputs -- definitions used before model evaluation to configure agents, threads, and messages
  //

  // Preview tools (must end with "_preview"):
  union _PreviewAgentToolType {
    a2a_preview: "a2a_preview",
    bing_custom_search_preview: "bing_custom_search_preview",
    browser_automation_preview: "browser_automation_preview",
    fabric_dataagent_preview: "fabric_dataagent_preview",
    sharepoint_grounding_preview: "sharepoint_grounding_preview",
    memory_search_preview: "memory_search_preview",
  }

  // General availability tools:
  union _AgentToolType {
    azure_ai_search: "azure_ai_search",
    azure_function: "azure_function",
    bing_grounding: "bing_grounding",
    capture_structured_outputs: "capture_structured_outputs",
    openapi: "openapi",

    @removed(Versions.v1)
    memory_search: "memory_search",
  }

  @@copyVariants(OpenAI.ToolType, Azure.AI.Projects._PreviewAgentToolType);
  @@copyVariants(OpenAI.ToolType, Azure.AI.Projects._AgentToolType);

  union _AgentIncludable {
    "memory_search_call.results",
  }

  #suppress "@azure-tools/typespec-azure-core/experimental-feature" "Using experimental feature"
  @@copyVariants(OpenAI.IncludeEnum, Azure.AI.Projects._AgentIncludable);

  #suppress "@azure-tools/typespec-azure-core/experimental-feature" "Using experimental feature"
  @@copyProperties(OpenAI.MCPTool,
    {
      /**
       * The connection ID in the project for the MCP server.
       */
      project_connection_id?: string,
    }
  );

  #suppress "@azure-tools/typespec-azure-core/experimental-feature" "Using experimental feature"
  @@copyProperties(OpenAI.WebSearchTool,
    {
      /**
       * The project connections attached to this tool.
       */
      custom_search_configuration?: WebSearchConfiguration,
    }
  );

  model WebSearchConfiguration {
    project_connection_id: string;
    instance_name: string;
  }

  model BingGroundingTool extends OpenAI.Tool {
    type: "bing_grounding";
    bing_grounding: BingGroundingSearchToolParameters;
  }

  model FabricDataAgentToolParameters {
    @maxItems(1)
    project_connections?: ToolProjectConnection[];
  }

  model MicrosoftFabricPreviewTool extends OpenAI.Tool {
    type: "fabric_dataagent_preview";
    fabric_dataagent_preview: FabricDataAgentToolParameters;
  }

  model SharepointGroundingToolParameters {
    @maxItems(1)
    project_connections?: ToolProjectConnection[];
  }

  model SharepointPreviewTool extends OpenAI.Tool {
    type: "sharepoint_grounding_preview";
    sharepoint_grounding_preview: SharepointGroundingToolParameters;
  }

  model AzureAISearchTool extends OpenAI.Tool {
    type: "azure_ai_search";
    azure_ai_search: AzureAISearchToolResource;
  }

  model AzureAISearchToolResource {
    @maxItems(1)
    indexes: AISearchIndexResource[];
  }

  model IndexResource {
    project_connection_id?: string;
    index_name?: string;
  }

  model AISearchIndexResource {
    ...IndexResource;
    query_type?: AzureAISearchQueryType;
    top_k?: int32;
    filter?: string;
    index_asset_id?: string;
  }

  union AzureAISearchQueryType {
    string,
    simple: "simple",
    semantic: "semantic",
    vector: "vector",
    vector_simple_hybrid: "vector_simple_hybrid",
    vector_semantic_hybrid: "vector_semantic_hybrid",
  }

  model OpenApiTool extends OpenAI.Tool {
    type: "openapi";
    openapi: OpenApiFunctionDefinition;
  }

  model BingCustomSearchPreviewTool extends OpenAI.Tool {
    type: "bing_custom_search_preview";
    bing_custom_search_preview: BingCustomSearchToolParameters;
  }

  model BrowserAutomationPreviewTool extends OpenAI.Tool {
    type: "browser_automation_preview";
    browser_automation_preview: BrowserAutomationToolParameters;
  }

  model BrowserAutomationToolParameters {
    connection: BrowserAutomationToolConnectionParameters;
  }

  model BrowserAutomationToolConnectionParameters {
    project_connection_id: string;
  }

  model AzureFunctionTool extends OpenAI.Tool {
    type: "azure_function";
    azure_function: AzureFunctionDefinition;
  }

  model AzureFunctionDefinition {
    function: {
      name: string;
      description?: string;
      #suppress "@azure-tools/typespec-azure-core/no-unknown" "External API shape takes an arbitrary json"
      parameters: Record<unknown>;
    };
    input_binding: AzureFunctionBinding;
    output_binding: AzureFunctionBinding;
  }

  model OpenApiFunctionDefinition {
    name: string;
    description?: string;
    spec: Record<unknown>;
    auth: OpenApiAuthDetails;
    default_params?: string[];

    @visibility(Lifecycle.Read)
    functions?: {
      name: string;
      description?: string;
      #suppress "@azure-tools/typespec-azure-core/no-unknown" "External API shape takes an arbitrary json"
      parameters: Record<unknown>;
    }[];
  }

  union OpenApiAuthType {
    anonymous: "anonymous",
    project_connection: "project_connection",
    managedIdentity: "managed_identity",
    string,
  }

  @discriminator("type")
  model OpenApiAuthDetails {
    type: OpenApiAuthType;
  }

  model OpenApiAnonymousAuthDetails extends OpenApiAuthDetails {
    type: OpenApiAuthType.anonymous;
  }

  model OpenApiProjectConnectionAuthDetails extends OpenApiAuthDetails {
    type: OpenApiAuthType.project_connection;
    security_scheme: OpenApiProjectConnectionSecurityScheme;
  }

  model OpenApiManagedAuthDetails extends OpenApiAuthDetails {
    type: OpenApiAuthType.managedIdentity;
    security_scheme: OpenApiManagedSecurityScheme;
  }

  model OpenApiManagedSecurityScheme {
    audience: string;
  }

  model OpenApiProjectConnectionSecurityScheme {
    project_connection_id: string;
  }

  model ToolProjectConnection {
    project_connection_id: string;
  }

  model ToolProjectConnectionList {
    @maxItems(1)
    project_connections?: ToolProjectConnection[];
  }

  model BingGroundingSearchConfiguration {
    project_connection_id: string;
    market?: string;
    set_lang?: string;
    count?: int64;
    freshness?: string;
  }

  model BingGroundingSearchToolParameters {
    @maxItems(1)
    search_configurations: BingGroundingSearchConfiguration[];
  }

  model BingCustomSearchToolParameters {
    @maxItems(1)
    search_configurations: BingCustomSearchConfiguration[];
  }

  model BingCustomSearchConfiguration {
    project_connection_id: string;
    instance_name: string;
    market?: string;
    set_lang?: string;
    count?: int64;
    freshness?: string;
  }

  model AzureFunctionBinding {
    type: "storage_queue";
    storage_queue: AzureFunctionStorageQueue;
  }

  model AzureFunctionStorageQueue {
    queue_service_endpoint: string;
    queue_name: string;
  }

  model StructuredOutputDefinition {
    name: string;
    description: string;
    schema: Record<unknown>;
    strict: boolean | null;
  }

  model CaptureStructuredOutputsTool extends OpenAI.Tool {
    type: "capture_structured_outputs";
    outputs: StructuredOutputDefinition;
  }

  model A2APreviewTool extends OpenAI.Tool {
    type: "a2a_preview";
    base_url?: url;
    agent_card_path?: string;
    project_connection_id?: string;
  }

  // ---- Memory search (inlined from memory-stores/models.tsp) ----

  model MemorySearchOptions {
    @doc("Maximum number of memory items to return.")
    max_memories?: int32;
  }

  model MemorySearchItem {
    @doc("Retrieved memory item.")
    memory_item: MemoryItem;
  }

  model MemoryItem {
    id?: string;
    content?: string;
    kind?: string;
  }

  model MemorySearchPreviewTool extends OpenAI.Tool {
    type: "memory_search_preview";
    memory_store_name: string;
    scope: string;
    search_options?: MemorySearchOptions;
    update_delay?: int32 = 300;
  }

  @removed(Versions.v1)
  model MemorySearchTool extends OpenAI.Tool {
    type: "memory_search";
    memory_store_name: string;
    scope: string;
    search_options?: MemorySearchOptions;
    update_delay?: int32 = 300;
  }

  alias MemorySearchToolCallItemBase = {
    @doc("The results returned from the memory search.")
    results?: MemorySearchItem[] | null;
  };

  model MemorySearchToolCallItemParam extends OpenAI.Item {
    type: "memory_search_call";
    ...MemorySearchToolCallItemBase;
  }

  model MemorySearchToolCallItemResource extends OpenAI.OutputItem {
    type: "memory_search_call";
    #suppress "@azure-tools/typespec-azure-core/no-unnamed-union" ""
    status: "in_progress" | "searching" | "completed" | "incomplete" | "failed";
    ...MemorySearchToolCallItemBase;
  }

  // ==============================================================================
  // Tool Call Status
  // ==============================================================================

  union ToolCallStatus {
    in_progress: "in_progress",
    completed: "completed",
    incomplete: "incomplete",
    failed: "failed",
  }

  #suppress "@azure-tools/typespec-azure-core/no-unnamed-union" "Output can be multiple types"
  union ToolCallOutputContent {
    Record<unknown>,
    string,
    unknown[],
  }

  // ==============================================================================
  // Tool Call Output Models
  // ==============================================================================

  model BingGroundingToolCall extends OpenAI.OutputItem {
    type: "bing_grounding_call";
    call_id: string;
    arguments: string;
    status: ToolCallStatus;
  }

  model BingGroundingToolCallOutput extends OpenAI.OutputItem {
    type: "bing_grounding_call_output";
    call_id: string;
    output?: ToolCallOutputContent;
    status: ToolCallStatus;
  }

  model SharepointGroundingToolCall extends OpenAI.OutputItem {
    type: "sharepoint_grounding_preview_call";
    call_id: string;
    arguments: string;
    status: ToolCallStatus;
  }

  model SharepointGroundingToolCallOutput extends OpenAI.OutputItem {
    type: "sharepoint_grounding_preview_call_output";
    call_id: string;
    output?: ToolCallOutputContent;
    status: ToolCallStatus;
  }

  model AzureAISearchToolCall extends OpenAI.OutputItem {
    type: "azure_ai_search_call";
    call_id: string;
    arguments: string;
    status: ToolCallStatus;
  }

  model AzureAISearchToolCallOutput extends OpenAI.OutputItem {
    type: "azure_ai_search_call_output";
    call_id: string;
    output?: ToolCallOutputContent;
    status: ToolCallStatus;
  }

  model BingCustomSearchToolCall extends OpenAI.OutputItem {
    type: "bing_custom_search_preview_call";
    call_id: string;
    arguments: string;
    status: ToolCallStatus;
  }

  model BingCustomSearchToolCallOutput extends OpenAI.OutputItem {
    type: "bing_custom_search_preview_call_output";
    call_id: string;
    output?: ToolCallOutputContent;
    status: ToolCallStatus;
  }

  model OpenApiToolCall extends OpenAI.OutputItem {
    type: "openapi_call";
    call_id: string;
    name: string;
    arguments: string;
    status: ToolCallStatus;
  }

  model OpenApiToolCallOutput extends OpenAI.OutputItem {
    type: "openapi_call_output";
    call_id: string;
    name: string;
    output?: ToolCallOutputContent;
    status: ToolCallStatus;
  }

  model BrowserAutomationToolCall extends OpenAI.OutputItem {
    type: "browser_automation_preview_call";
    call_id: string;
    arguments: string;
    status: ToolCallStatus;
  }

  model BrowserAutomationToolCallOutput extends OpenAI.OutputItem {
    type: "browser_automation_preview_call_output";
    call_id: string;
    output?: ToolCallOutputContent;
    status: ToolCallStatus;
  }

  model FabricDataAgentToolCall extends OpenAI.OutputItem {
    type: "fabric_dataagent_preview_call";
    call_id: string;
    arguments: string;
    status: ToolCallStatus;
  }

  model FabricDataAgentToolCallOutput extends OpenAI.OutputItem {
    type: "fabric_dataagent_preview_call_output";
    call_id: string;
    output?: ToolCallOutputContent;
    status: ToolCallStatus;
  }

  model AzureFunctionToolCall extends OpenAI.OutputItem {
    type: "azure_function_call";
    call_id: string;
    name: string;
    arguments: string;
    status: ToolCallStatus;
  }

  model AzureFunctionToolCallOutput extends OpenAI.OutputItem {
    type: "azure_function_call_output";
    call_id: string;
    name: string;
    output?: ToolCallOutputContent;
    status: ToolCallStatus;
  }

  model A2AToolCall extends OpenAI.OutputItem {
    type: "a2a_preview_call";
    call_id: string;
    name: string;
    arguments: string;
    status: ToolCallStatus;
  }

  model A2AToolCallOutput extends OpenAI.OutputItem {
    type: "a2a_preview_call_output";
    call_id: string;
    name: string;
    output?: ToolCallOutputContent;
    status: ToolCallStatus;
  }
}
