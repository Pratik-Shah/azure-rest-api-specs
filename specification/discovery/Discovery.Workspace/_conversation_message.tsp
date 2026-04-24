import "@typespec/rest";
import "@typespec/versioning";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-core/experimental";
import "./common.tsp";
import "./_conversation.tsp";

using TypeSpec.Http;
using TypeSpec.Rest;
using TypeSpec.Versioning;
using Azure.Core;
using Azure.Core.Traits;
using Azure.Core.Experimental;

using Microsoft.Discovery.Common;

@versioned(Microsoft.Discovery.Workspace.Versions)
namespace Microsoft.Discovery.Workspace;

/*
@doc("The type of the message asset.")
@added(Versions.`2026-02-01-preview`)
union MessageAssetKind {
  StorageAsset: "StorageAsset",
  string,
}
*/

@doc("Data asset")
@removed(Versions.`2026-02-01-preview`)
model DataAsset {
  @doc("DataAsset id")
  @visibility(Lifecycle.Read, Lifecycle.Create)
  dataAssetId: DataAssetId;

  /** Asset name */
  // TODO: Are we sure we want/need this?
  @visibility(Lifecycle.Read, Lifecycle.Create)
  name: string;

  ...WithCreated;
}

@doc("A body for creating a message.")
@removed(Versions.`2026-02-01-preview`)
model MessageCreateBody {
  @doc("The message text.")
  @visibility(Lifecycle.Read, Lifecycle.Create)
  text: string;
}

@doc("A message list item containing just the message name.")
@removed(Versions.`2026-02-01-preview`)
@resource("messages")
@parentResource(Conversation)
model MessageListItem {
  @doc("The message name.")
  @key("messageName")
  @visibility(Lifecycle.Read)
  name: string;
}

/*
@doc("Resource for response operations. Routes to /conversations/{conversationName}/openai/responses/{responseId}")
@added(Versions.`2026-02-01-preview`)
@resource("openai/responses")
@parentResource(Conversation)
model ConversationResponseResource {
  @doc("The response ID.")
  @key("responseId")
  @visibility(Lifecycle.Read)
  id: string;
}
*/

/** For adding DataAsset ID. */
alias WithDataAssetId = {
  /** ID of the related data asset */
  @visibility(Lifecycle.Read)
  @removed(Versions.`2026-02-01-preview`)
  dataAssetId: DataAssetId;
};

/*
@doc("For adding StorageAsset ID")
@added(Versions.`2026-02-01-preview`)
model WithStorageAssetId {
  // ID of the related storage asset
  @visibility(Lifecycle.Read)
  @added(Versions.`2026-02-01-preview`)
  storageAssetId: StorageAssetId;
}
*/

/** For adding key. */
alias WithKey = {
  /** Key used as identifier */
  @visibility(Lifecycle.Read)
  key: string;
};

@doc("Copilot citation")
@removed(Versions.`2026-02-01-preview`)
model Citation {
  ...WithKey;
  ...WithDataAssetId;

  /** URI from where citation originated */
  @visibility(Lifecycle.Read)
  sourceUri: string;

  /** Title to display */
  @visibility(Lifecycle.Read)
  title: string;

  /** Description */
  @visibility(Lifecycle.Read)
  description: string;

  /** List of start indices (e.g. character offsets) related to this citation. */
  @visibility(Lifecycle.Read, Lifecycle.Create)
  startIndices?: int32[];

  /** Citation type (category/discriminator). */
  @visibility(Lifecycle.Read, Lifecycle.Create)
  type?: string;
}

@doc("Enumeration for message status.")
@lroStatus
union MessageStatus {
  /** Message Accepted */
  Accepted: "Accepted",

  /** Message is awaiting user input */
  @removed(Versions.`2026-02-01-preview`)
  AwaitingUserInput: "AwaitingUserInput",

  /** Running */
  Running: "Running",

  /** Succeeded */
  @lroSucceeded
  Succeeded: "Succeeded",

  /** Canceled */
  @lroCanceled
  Cancelled: "Cancelled",

  /** Failed */
  @lroFailed
  Failed: "Failed",

  /** Expired */
  Expired: "Expired",

  /** Workflow is asking a question and awaiting user input */
  @added(Versions.`2026-02-01-preview`)
  WorkflowAskQuestion: "WorkflowAskQuestion",

  string,
}

// @doc("Expected input type when status is WorkflowAskQuestion.")
// @added(Versions.`2026-02-01-preview`)
// union NextInputType {
//   /** Boolean input expected */
//   boolean: "boolean",

//   /** Numeric input expected */
//   number: "number",

//   /** String input expected */
//   string: "string",

//   /** File input expected */
//   file: "file",

//   /** Data input expected */
//   data: "data",

//   /** DateTime input expected */
//   datetime: "datetime",

//   /** URL input expected */
//   url: "url",

//   string,
// }

@doc("A message.")
@resource("messages")
@parentResource(Conversation)
model ConversationMessage {
  @doc("The message name.")
  @visibility(Lifecycle.Read)
  @key("messageName")
  @maxLength(24)
  @pattern(resourceNamePattern)
  name: string;

  @doc("The conversation name.")
  @visibility(Lifecycle.Read)
  @pattern(conversationNamePattern)
  @removed(Versions.`2026-02-01-preview`)
  conversationName: string;

  //   ...ConversationPathContent;

  ...DataPlaneResource;

  // For 2026-02-01-preview, these are moved inside response.discovery
  @doc("The Name of the associated Investigation")
  @visibility(Lifecycle.Read, Lifecycle.Create)
  @removed(Versions.`2026-02-01-preview`)
  investigationName?: string;

  @doc("The name of the associated Project")
  @visibility(Lifecycle.Read, Lifecycle.Create)
  @removed(Versions.`2026-02-01-preview`)
  projectName?: string;

  ...WithSender;

  @doc("Message status.")
  @visibility(Lifecycle.Read)
  @removed(Versions.`2026-02-01-preview`)
  status?: MessageStatus;

  @doc("Citation list")
  @visibility(Lifecycle.Read)
  @removed(Versions.`2026-02-01-preview`)
  citations?: Citation[];

  @doc("Array of data assets.")
  @visibility(Lifecycle.Read)
  @removed(Versions.`2026-02-01-preview`)
  dataAssets?: DataAsset[];

  @doc("Array of confirmations related to this message.")
  @visibility(Lifecycle.Read)
  @removed(Versions.`2026-02-01-preview`)
  confirmations?: MessageConfirmation[];
}

@doc("A user confirmation for a copilot action related to a message.")
model MessageConfirmation {
  @doc("The confirmation name.")
  @visibility(Lifecycle.Read)
  @key("confirmationName")
  name: string;

  ...DataPlaneResource;

  @doc("Confirmation status")
  @visibility(Lifecycle.Read, Lifecycle.Update)
  @removed(Versions.`2026-02-01-preview`)
  status: ConfirmationStatus;

  @doc("Reason for status (e.g. deny reason)")
  @visibility(Lifecycle.Read, Lifecycle.Update)
  @removed(Versions.`2026-02-01-preview`)
  statusReason?: string;

  @doc("Name of the agent seeking confirmation")
  @visibility(Lifecycle.Read)
  agentName?: string;

  @doc("Name of the tool seeking confirmation")
  @visibility(Lifecycle.Read)
  toolName?: string;

  @doc("Arguments for the tool")
  @visibility(Lifecycle.Read)
  toolArguments?: string;
}

@doc("Enumeration for confirmation status.")
union ConfirmationStatus {
  /** Message is awaiting user input */
  @removed(Versions.`2026-02-01-preview`)
  AwaitingUserInput: "AwaitingUserInput",

  /** Message Confirmed */
  Confirmed: "Confirmed",

  /** Message Denied */
  Denied: "Denied",

  string,
}

@doc("A minimal response for confirmation status.")
model MessageConfirmationStatus {
  @doc("The confirmation name.")
  confirmationName: string;

  @doc("Enumeration for message status.")
  status: ConfirmationStatus;

  @doc("Reason for status (e.g. deny reason)")
  statusReason?: string;
}

alias ConversationPathContent = {
  @doc("The conversation name.")
  @path
  conversationName: string;
};

interface ConversationMessages {
  @doc("Fetch a Message by name.")
  @sharedRoute
  @removed(Versions.`2026-02-01-preview`)
  getMessageLegacy is ResourceRead<ConversationMessage>;

  #suppress "@azure-tools/typespec-azure-core/use-standard-operations" "Need custom body type MessageCreateBody"
  @doc("Creates a Message.")
  @post
  @createsResource(ConversationMessage)
  @sharedRoute
  @removed(Versions.`2026-02-01-preview`)
  createMessageLegacy is Foundations.ResourceCollectionOperation<
    ConversationMessage,
    MessageCreateBody,
    TypeSpec.Http.Response<201> &
      TypeSpec.Http.LocationHeader &
      ConversationMessage
  >;

  @doc("List Messages in specified conversation. Returns full message objects.")
  @sharedRoute
  @removed(Versions.`2026-02-01-preview`)
  listMessagesLegacy is ResourceList<
    ConversationMessage,
    QueryParametersTrait<WithQueryCreatedSince>
  >;

  @doc("Cancel current copilot operation.")
  @sharedRoute
  @action("cancel")
  @removed(Versions.`2026-02-01-preview`)
  cancelLegacy is Operations.ResourceAction<
    ConversationMessage,
    {},
    ConversationMessage
  >;

  @doc("Submit user input in response to AwaitingUserInput status.")
  @sharedRoute
  @action("submitUserInput")
  @removed(Versions.`2026-02-01-preview`)
  submitUserInputLegacy is Operations.ResourceAction<
    ConversationMessage,
    MessageConfirmationStatus,
    {}
  >;

  // NOTE: These APIs are actually what the service exposes, but we need to collaborate with the API
  // specs owners and SDK archboard to determine the ideal way to consume these models. For now, they will
  // be excluded from our specs and SDKs, but still exposed by the service.
  /*
  #suppress "@azure-tools/typespec-azure-core/use-standard-operations" "Need OpenAI.Response return type"
  @doc("Fetch a Response by name. Returns the OpenAI Response with Discovery extensions.")
  @get
  @added(Versions.`2026-02-01-preview`)
  getResponse is Foundations.ResourceOperation<
    ConversationResponseResource,
    {},
    OpenAI.Response
  >;

  #suppress "@azure-tools/typespec-azure-core/use-standard-operations" "Need ResponseItemList return type"
  @doc("Get input items for a Response. Returns the OpenAI ResponseItemList with Discovery extensions containing storage assets.")
  @get
  @route("/conversations/{conversationName}/openai/responses/{responseId}/inputs")
  @added(Versions.`2026-02-01-preview`)
  getResponseInputs(
    ...Azure.Core.Foundations.ApiVersionParameter,
    ...ConversationPathContent,

    @doc("The response ID.")
    @path
    responseId: string,
  ): OpenAI.ResponseItemList;

  #suppress "@azure-tools/typespec-azure-core/use-standard-operations" "Need custom body type and OpenAI.Response return"
  @doc("Creates a Response. Returns the OpenAI Response with Discovery extensions.")
  @post
  @createsResource(ConversationResponseResource)
  @added(Versions.`2026-02-01-preview`)
  createResponse is Foundations.ResourceCollectionOperation<
    ConversationResponseResource,
    OpenAI.CreateResponse,
    TypeSpec.Http.Response<201> & TypeSpec.Http.LocationHeader & OpenAI.Response
  >;

  #suppress "@azure-tools/typespec-azure-core/use-standard-operations" "Need ResponseList return type"
  #suppress "@azure-tools/typespec-azure-core/use-standard-names" "List operation returns ResponseList"
  @doc("List Responses in specified conversation. Returns a list of OpenAI Responses with Discovery extensions.")
  @get
  @route("/conversations/{conversationName}/openai/responses")
  @added(Versions.`2026-02-01-preview`)
  listResponses(
    ...Azure.Core.Foundations.ApiVersionParameter,
    ...ConversationPathContent,
    ...WithQueryCreatedSince,
  ): Azure.AI.Projects.ResponseList;

  #suppress "@azure-tools/typespec-azure-core/use-standard-operations" "Need custom route and OpenAI.Response return type"
  @doc("Cancel current copilot operation. Returns the OpenAI Response with Discovery extensions.")
  @route("/conversations/{conversationName}/openai/responses/{responseId}/cancel")
  @post
  @added(Versions.`2026-02-01-preview`)
  cancelResponse is Azure.Core.Foundations.Operation<
    {
      ...ConversationPathContent;

      @doc("The response ID.")
      @path
      responseId: string;
    },
    OpenAI.Response
  >;

  #suppress "@azure-tools/typespec-azure-core/use-standard-operations" "Need OpenAI.Response return type"
  @doc("Submit user input in response for tool confirmations. Returns the OpenAI Response with Discovery extensions.")
  @action("submitUserInput")
  @added(Versions.`2026-02-01-preview`)
  submitUserInput is Operations.ResourceAction<
    ConversationResponseResource,
    MessageConfirmationStatus,
    OpenAI.Response
  >;
  */
}

// NOTE: These APIs are actually what the service exposes, but we need to collaborate with the API
// specs owners and SDK archboard to determine the ideal way to consume these models. For now, they will
// be excluded from our specs and SDKs, but still exposed by the service.
/*
@doc("Discovery-specific extensions.")
@added(Versions.`2026-02-01-preview`)
model DiscoveryProperties {
  @doc("Array of storage asset IDs.")
  @visibility(Lifecycle.Create, Lifecycle.Read)
  storageAssets?: StorageAssetId[];

  @doc("Array of confirmations related to this response.")
  @visibility(Lifecycle.Read)
  confirmations?: MessageConfirmation[];

  @doc("Discovery-specific metadata keyed by output item ID. Maps item_id to extension data.")
  @visibility(Lifecycle.Read)
  itemExtensions?: Record<Record<unknown>>;

  @doc("The investigation name associated with this response.")
  @visibility(Lifecycle.Read)
  investigationName?: string;

  @doc("The project name associated with this response.")
  @visibility(Lifecycle.Read)
  projectName?: string;

  ...WithCreatedBy;
  ...WithCreatedByType;
}

#suppress "@azure-tools/typespec-azure-core/experimental-feature" "Using experimental copyProperties"
@@copyProperties(OpenAI.CreateResponse,
  {
    discoveryProperties?: DiscoveryProperties,
  }
);

#suppress "@azure-tools/typespec-azure-core/experimental-feature" "Using experimental copyProperties"
@@copyProperties(OpenAI.Response,
  {
    discoveryProperties?: DiscoveryProperties,
  }
);

#suppress "@azure-tools/typespec-azure-core/experimental-feature" "Using experimental copyProperties"
@@copyProperties(OpenAI.ResponseItemList,
  {
    discoveryProperties?: DiscoveryProperties,
  }
);
*/

// ============================================================================
// Discovery v1 Response API (2026-06-01) — based on Foundry v1
// ============================================================================

@doc("Resource for response operations in v1. Routes to /conversations/{conversationName}/openai/v1/responses/{responseId}")
@added(Versions.`2026-06-01`)
@resource("openai/v1/responses")
@parentResource(Conversation)
model ConversationResponseResource {
  @doc("The response ID.")
  @key("responseId")
  @visibility(Lifecycle.Read)
  id: string;
}

@doc("Discovery-specific extensions added to Foundry Response objects.")
@added(Versions.`2026-06-01`)
model DiscoveryProperties {
  @doc("Array of storage asset IDs.")
  @visibility(Lifecycle.Create, Lifecycle.Read)
  storageAssets?: StorageAssetId[];

  @doc("Array of confirmations related to this response.")
  @visibility(Lifecycle.Read)
  confirmations?: MessageConfirmation[];

  @doc("Discovery-specific metadata keyed by output item ID. Maps item_id to extension data.")
  @visibility(Lifecycle.Read)
  itemExtensions?: Record<Record<unknown>>;

  @doc("The investigation name associated with this response.")
  @visibility(Lifecycle.Read)
  investigationName?: string;

  @doc("The project name associated with this response.")
  @visibility(Lifecycle.Read)
  projectName?: string;

  ...WithCreatedBy;
  ...WithCreatedByType;
}

// Apply Discovery extensions on top of Foundry v1 extensions
#suppress "@azure-tools/typespec-azure-core/experimental-feature" "Using experimental copyProperties for Discovery extensions"
@@copyProperties(OpenAI.CreateResponse,
  {
    @added(Versions.`2026-06-01`)
    discoveryProperties?: DiscoveryProperties,
  }
);

#suppress "@azure-tools/typespec-azure-core/experimental-feature" "Using experimental copyProperties for Discovery extensions"
@@copyProperties(OpenAI.Response,
  {
    @added(Versions.`2026-06-01`)
    discoveryProperties?: DiscoveryProperties,
  }
);

@doc("Paged list of response input items with Discovery extensions.")
@added(Versions.`2026-06-01`)
model ResponseItemList {
  @doc("The object type, which is always 'list'.")
  object: "list";

  @doc("The list of input items.")
  @pageItems
  data: OpenAI.OutputItem[];

  @doc("The first ID represented in this list.")
  first_id?: string;

  @doc("The last ID represented in this list.")
  @continuationToken
  last_id?: string;

  @doc("A value indicating whether there are additional values available not captured in this list.")
  has_more: boolean;

  @doc("Discovery-specific extensions.")
  discoveryProperties?: DiscoveryProperties;
}

// ============================================================================
// v1 Response API Interface
// ============================================================================

@added(Versions.`2026-06-01`)
interface ConversationResponses {
  #suppress "@azure-tools/typespec-azure-core/use-standard-operations" "Need custom body type and OpenAI.Response return"
  @doc("Creates a Response. Returns the Foundry v1 Response with Discovery extensions.")
  @post
  @createsResource(ConversationResponseResource)
  createResponse is Foundations.ResourceCollectionOperation<
    ConversationResponseResource,
    OpenAI.CreateResponse,
    TypeSpec.Http.Response<201> & TypeSpec.Http.LocationHeader & OpenAI.Response
  >;

  #suppress "@azure-tools/typespec-azure-core/use-standard-operations" "Need OpenAI.Response return type"
  @doc("Retrieves a Response by ID. Returns the Foundry v1 Response with Discovery extensions.")
  @get
  getResponse is Foundations.ResourceOperation<
    ConversationResponseResource,
    {},
    OpenAI.Response
  >;

  #suppress "@azure-tools/typespec-azure-core/use-standard-operations" "Need paged result with Foundry v1 OutputItem"
  @doc("Get input items for a Response. Returns the OpenAI ResponseItemList with Discovery extensions containing storage assets.")
  @get
  @route("/conversations/{conversationName}/openai/v1/responses/{responseId}/inputs")
  listInputItems(
    ...Azure.Core.Foundations.ApiVersionParameter,
    ...ConversationPathContent,

    @doc("The response ID.")
    @path
    responseId: string,

    ...FoundryPageQueryParams,
  ): ResponseItemList;

  #suppress "@azure-tools/typespec-azure-core/use-standard-operations" "Need paged result of OpenAI.Response"
  #suppress "@azure-tools/typespec-azure-core/use-standard-names" "List operation returns FoundryPagedResult"
  @doc("Lists all Responses in a conversation.")
  @get
  @route("/conversations/{conversationName}/openai/v1/responses")
  listResponses(
    ...Azure.Core.Foundations.ApiVersionParameter,
    ...ConversationPathContent,
    ...FoundryPageQueryParams,
    ...WithQueryCreatedSince,
  ): FoundryPagedResult<OpenAI.Response>;

  #suppress "@azure-tools/typespec-azure-core/use-standard-operations" "Need custom route and OpenAI.Response return type"
  @doc("Cancels an in-progress Response.")
  @route("/conversations/{conversationName}/openai/v1/responses/{responseId}/cancel")
  @post
  cancelResponse is Azure.Core.Foundations.Operation<
    {
      ...ConversationPathContent;

      @doc("The response ID.")
      @path
      responseId: string;
    },
    OpenAI.Response
  >;

  #suppress "@azure-tools/typespec-azure-core/use-standard-operations" "Need OpenAI.Response return type"
  @doc("Submit user input in response for tool confirmations.")
  @action("submitUserInput")
  submitUserInput is Operations.ResourceAction<
    ConversationResponseResource,
    MessageConfirmationStatus,
    OpenAI.Response
  >;
}
