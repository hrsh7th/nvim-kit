local LSP = {}

---@enum ___plugin_name___.kit.LSP.SemanticTokenTypes
LSP.SemanticTokenTypes = {
  namespace = 'namespace',
  type = 'type',
  class = 'class',
  enum = 'enum',
  interface = 'interface',
  struct = 'struct',
  typeParameter = 'typeParameter',
  parameter = 'parameter',
  variable = 'variable',
  property = 'property',
  enumMember = 'enumMember',
  event = 'event',
  ['function'] = 'function',
  method = 'method',
  macro = 'macro',
  keyword = 'keyword',
  modifier = 'modifier',
  comment = 'comment',
  string = 'string',
  number = 'number',
  regexp = 'regexp',
  operator = 'operator',
  decorator = 'decorator',
}

---@enum ___plugin_name___.kit.LSP.SemanticTokenModifiers
LSP.SemanticTokenModifiers = {
  declaration = 'declaration',
  definition = 'definition',
  readonly = 'readonly',
  static = 'static',
  deprecated = 'deprecated',
  abstract = 'abstract',
  async = 'async',
  modification = 'modification',
  documentation = 'documentation',
  defaultLibrary = 'defaultLibrary',
}

---@enum ___plugin_name___.kit.LSP.DocumentDiagnosticReportKind
LSP.DocumentDiagnosticReportKind = {
  Full = 'full',
  Unchanged = 'unchanged',
}

---@enum ___plugin_name___.kit.LSP.ErrorCodes
LSP.ErrorCodes = {
  ParseError = -32700,
  InvalidRequest = -32600,
  MethodNotFound = -32601,
  InvalidParams = -32602,
  InternalError = -32603,
  ServerNotInitialized = -32002,
  UnknownErrorCode = -32001,
}

---@enum ___plugin_name___.kit.LSP.LSPErrorCodes
LSP.LSPErrorCodes = {
  RequestFailed = -32803,
  ServerCancelled = -32802,
  ContentModified = -32801,
  RequestCancelled = -32800,
}

---@enum ___plugin_name___.kit.LSP.FoldingRangeKind
LSP.FoldingRangeKind = {
  Comment = 'comment',
  Imports = 'imports',
  Region = 'region',
}

---@enum ___plugin_name___.kit.LSP.SymbolKind
LSP.SymbolKind = {
  File = 1,
  Module = 2,
  Namespace = 3,
  Package = 4,
  Class = 5,
  Method = 6,
  Property = 7,
  Field = 8,
  Constructor = 9,
  Enum = 10,
  Interface = 11,
  Function = 12,
  Variable = 13,
  Constant = 14,
  String = 15,
  Number = 16,
  Boolean = 17,
  Array = 18,
  Object = 19,
  Key = 20,
  Null = 21,
  EnumMember = 22,
  Struct = 23,
  Event = 24,
  Operator = 25,
  TypeParameter = 26,
}

---@enum ___plugin_name___.kit.LSP.SymbolTag
LSP.SymbolTag = {
  Deprecated = 1,
}

---@enum ___plugin_name___.kit.LSP.UniquenessLevel
LSP.UniquenessLevel = {
  document = 'document',
  project = 'project',
  group = 'group',
  scheme = 'scheme',
  global = 'global',
}

---@enum ___plugin_name___.kit.LSP.MonikerKind
LSP.MonikerKind = {
  import = 'import',
  export = 'export',
  ['local'] = 'local',
}

---@enum ___plugin_name___.kit.LSP.InlayHintKind
LSP.InlayHintKind = {
  Type = 1,
  Parameter = 2,
}

---@enum ___plugin_name___.kit.LSP.MessageType
LSP.MessageType = {
  Error = 1,
  Warning = 2,
  Info = 3,
  Log = 4,
}

---@enum ___plugin_name___.kit.LSP.TextDocumentSyncKind
LSP.TextDocumentSyncKind = {
  None = 0,
  Full = 1,
  Incremental = 2,
}

---@enum ___plugin_name___.kit.LSP.TextDocumentSaveReason
LSP.TextDocumentSaveReason = {
  Manual = 1,
  AfterDelay = 2,
  FocusOut = 3,
}

---@enum ___plugin_name___.kit.LSP.CompletionItemKind
LSP.CompletionItemKind = {
  Text = 1,
  Method = 2,
  Function = 3,
  Constructor = 4,
  Field = 5,
  Variable = 6,
  Class = 7,
  Interface = 8,
  Module = 9,
  Property = 10,
  Unit = 11,
  Value = 12,
  Enum = 13,
  Keyword = 14,
  Snippet = 15,
  Color = 16,
  File = 17,
  Reference = 18,
  Folder = 19,
  EnumMember = 20,
  Constant = 21,
  Struct = 22,
  Event = 23,
  Operator = 24,
  TypeParameter = 25,
}

---@enum ___plugin_name___.kit.LSP.CompletionItemTag
LSP.CompletionItemTag = {
  Deprecated = 1,
}

---@enum ___plugin_name___.kit.LSP.InsertTextFormat
LSP.InsertTextFormat = {
  PlainText = 1,
  Snippet = 2,
}

---@enum ___plugin_name___.kit.LSP.InsertTextMode
LSP.InsertTextMode = {
  asIs = 1,
  adjustIndentation = 2,
}

---@enum ___plugin_name___.kit.LSP.DocumentHighlightKind
LSP.DocumentHighlightKind = {
  Text = 1,
  Read = 2,
  Write = 3,
}

---@enum ___plugin_name___.kit.LSP.CodeActionKind
LSP.CodeActionKind = {
  Empty = '',
  QuickFix = 'quickfix',
  Refactor = 'refactor',
  RefactorExtract = 'refactor.extract',
  RefactorInline = 'refactor.inline',
  RefactorRewrite = 'refactor.rewrite',
  Source = 'source',
  SourceOrganizeImports = 'source.organizeImports',
  SourceFixAll = 'source.fixAll',
}

---@enum ___plugin_name___.kit.LSP.TraceValues
LSP.TraceValues = {
  Off = 'off',
  Messages = 'messages',
  Verbose = 'verbose',
}

---@enum ___plugin_name___.kit.LSP.MarkupKind
LSP.MarkupKind = {
  PlainText = 'plaintext',
  Markdown = 'markdown',
}

---@enum ___plugin_name___.kit.LSP.PositionEncodingKind
LSP.PositionEncodingKind = {
  UTF8 = 'utf-8',
  UTF16 = 'utf-16',
  UTF32 = 'utf-32',
}

---@enum ___plugin_name___.kit.LSP.FileChangeType
LSP.FileChangeType = {
  Created = 1,
  Changed = 2,
  Deleted = 3,
}

---@enum ___plugin_name___.kit.LSP.WatchKind
LSP.WatchKind = {
  Create = 1,
  Change = 2,
  Delete = 4,
}

---@enum ___plugin_name___.kit.LSP.DiagnosticSeverity
LSP.DiagnosticSeverity = {
  Error = 1,
  Warning = 2,
  Information = 3,
  Hint = 4,
}

---@enum ___plugin_name___.kit.LSP.DiagnosticTag
LSP.DiagnosticTag = {
  Unnecessary = 1,
  Deprecated = 2,
}

---@enum ___plugin_name___.kit.LSP.CompletionTriggerKind
LSP.CompletionTriggerKind = {
  Invoked = 1,
  TriggerCharacter = 2,
  TriggerForIncompleteCompletions = 3,
}

---@enum ___plugin_name___.kit.LSP.SignatureHelpTriggerKind
LSP.SignatureHelpTriggerKind = {
  Invoked = 1,
  TriggerCharacter = 2,
  ContentChange = 3,
}

---@enum ___plugin_name___.kit.LSP.CodeActionTriggerKind
LSP.CodeActionTriggerKind = {
  Invoked = 1,
  Automatic = 2,
}

---@enum ___plugin_name___.kit.LSP.FileOperationPatternKind
LSP.FileOperationPatternKind = {
  file = 'file',
  folder = 'folder',
}

---@enum ___plugin_name___.kit.LSP.NotebookCellKind
LSP.NotebookCellKind = {
  Markup = 1,
  Code = 2,
}

---@enum ___plugin_name___.kit.LSP.ResourceOperationKind
LSP.ResourceOperationKind = {
  Create = 'create',
  Rename = 'rename',
  Delete = 'delete',
}

---@enum ___plugin_name___.kit.LSP.FailureHandlingKind
LSP.FailureHandlingKind = {
  Abort = 'abort',
  Transactional = 'transactional',
  TextOnlyTransactional = 'textOnlyTransactional',
  Undo = 'undo',
}

---@enum ___plugin_name___.kit.LSP.PrepareSupportDefaultBehavior
LSP.PrepareSupportDefaultBehavior = {
  Identifier = 1,
}

---@enum ___plugin_name___.kit.LSP.TokenFormat
LSP.TokenFormat = {
  Relative = 'relative',
}

---@class ___plugin_name___.kit.LSP.ImplementationParams : ___plugin_name___.kit.LSP.TextDocumentPositionParams

---@class ___plugin_name___.kit.LSP.Location
---@field public uri string
---@field public range ___plugin_name___.kit.LSP.Range

---@class ___plugin_name___.kit.LSP.ImplementationRegistrationOptions : ___plugin_name___.kit.LSP.TextDocumentRegistrationOptions

---@class ___plugin_name___.kit.LSP.TypeDefinitionParams : ___plugin_name___.kit.LSP.TextDocumentPositionParams

---@class ___plugin_name___.kit.LSP.TypeDefinitionRegistrationOptions : ___plugin_name___.kit.LSP.TextDocumentRegistrationOptions

---@class ___plugin_name___.kit.LSP.WorkspaceFolder
---@field public uri string
---@field public name string

---@class ___plugin_name___.kit.LSP.DidChangeWorkspaceFoldersParams
---@field public event ___plugin_name___.kit.LSP.WorkspaceFoldersChangeEvent

---@class ___plugin_name___.kit.LSP.ConfigurationParams
---@field public items ___plugin_name___.kit.LSP.ConfigurationItem[]

---@class ___plugin_name___.kit.LSP.PartialResultParams
---@field public partialResultToken ___plugin_name___.kit.LSP.ProgressToken

---@class ___plugin_name___.kit.LSP.DocumentColorParams
---@field public textDocument ___plugin_name___.kit.LSP.TextDocumentIdentifier

---@class ___plugin_name___.kit.LSP.ColorInformation
---@field public range ___plugin_name___.kit.LSP.Range
---@field public color ___plugin_name___.kit.LSP.Color

---@class ___plugin_name___.kit.LSP.DocumentColorRegistrationOptions : ___plugin_name___.kit.LSP.TextDocumentRegistrationOptions

---@class ___plugin_name___.kit.LSP.ColorPresentationParams
---@field public textDocument ___plugin_name___.kit.LSP.TextDocumentIdentifier
---@field public color ___plugin_name___.kit.LSP.Color
---@field public range ___plugin_name___.kit.LSP.Range

---@class ___plugin_name___.kit.LSP.ColorPresentation
---@field public label string
---@field public textEdit ___plugin_name___.kit.LSP.TextEdit
---@field public additionalTextEdits ___plugin_name___.kit.LSP.TextEdit[]

---@class ___plugin_name___.kit.LSP.WorkDoneProgressOptions
---@field public workDoneProgress boolean

---@class ___plugin_name___.kit.LSP.TextDocumentRegistrationOptions
---@field public documentSelector (___plugin_name___.kit.LSP.DocumentSelector | nil)

---@class ___plugin_name___.kit.LSP.FoldingRangeParams
---@field public textDocument ___plugin_name___.kit.LSP.TextDocumentIdentifier

---@class ___plugin_name___.kit.LSP.FoldingRange
---@field public startLine integer
---@field public startCharacter integer
---@field public endLine integer
---@field public endCharacter integer
---@field public kind ___plugin_name___.kit.LSP.FoldingRangeKind
---@field public collapsedText string

---@class ___plugin_name___.kit.LSP.FoldingRangeRegistrationOptions : ___plugin_name___.kit.LSP.TextDocumentRegistrationOptions

---@class ___plugin_name___.kit.LSP.DeclarationParams : ___plugin_name___.kit.LSP.TextDocumentPositionParams

---@class ___plugin_name___.kit.LSP.DeclarationRegistrationOptions : ___plugin_name___.kit.LSP.DeclarationOptions

---@class ___plugin_name___.kit.LSP.SelectionRangeParams
---@field public textDocument ___plugin_name___.kit.LSP.TextDocumentIdentifier
---@field public positions ___plugin_name___.kit.LSP.Position[]

---@class ___plugin_name___.kit.LSP.SelectionRange
---@field public range ___plugin_name___.kit.LSP.Range
---@field public parent ___plugin_name___.kit.LSP.SelectionRange

---@class ___plugin_name___.kit.LSP.SelectionRangeRegistrationOptions : ___plugin_name___.kit.LSP.SelectionRangeOptions

---@class ___plugin_name___.kit.LSP.WorkDoneProgressCreateParams
---@field public token ___plugin_name___.kit.LSP.ProgressToken

---@class ___plugin_name___.kit.LSP.WorkDoneProgressCancelParams
---@field public token ___plugin_name___.kit.LSP.ProgressToken

---@class ___plugin_name___.kit.LSP.CallHierarchyPrepareParams : ___plugin_name___.kit.LSP.TextDocumentPositionParams

---@class ___plugin_name___.kit.LSP.CallHierarchyItem
---@field public name string
---@field public kind ___plugin_name___.kit.LSP.SymbolKind
---@field public tags ___plugin_name___.kit.LSP.SymbolTag[]
---@field public detail string
---@field public uri string
---@field public range ___plugin_name___.kit.LSP.Range
---@field public selectionRange ___plugin_name___.kit.LSP.Range
---@field public data ___plugin_name___.kit.LSP.LSPAny

---@class ___plugin_name___.kit.LSP.CallHierarchyRegistrationOptions : ___plugin_name___.kit.LSP.TextDocumentRegistrationOptions

---@class ___plugin_name___.kit.LSP.CallHierarchyIncomingCallsParams
---@field public item ___plugin_name___.kit.LSP.CallHierarchyItem

---@class ___plugin_name___.kit.LSP.CallHierarchyIncomingCall
---@field public from ___plugin_name___.kit.LSP.CallHierarchyItem
---@field public fromRanges ___plugin_name___.kit.LSP.Range[]

---@class ___plugin_name___.kit.LSP.CallHierarchyOutgoingCallsParams
---@field public item ___plugin_name___.kit.LSP.CallHierarchyItem

---@class ___plugin_name___.kit.LSP.CallHierarchyOutgoingCall
---@field public to ___plugin_name___.kit.LSP.CallHierarchyItem
---@field public fromRanges ___plugin_name___.kit.LSP.Range[]

---@class ___plugin_name___.kit.LSP.SemanticTokensParams
---@field public textDocument ___plugin_name___.kit.LSP.TextDocumentIdentifier

---@class ___plugin_name___.kit.LSP.SemanticTokens
---@field public resultId string
---@field public data integer[]

---@class ___plugin_name___.kit.LSP.SemanticTokensPartialResult
---@field public data integer[]

---@class ___plugin_name___.kit.LSP.SemanticTokensRegistrationOptions : ___plugin_name___.kit.LSP.TextDocumentRegistrationOptions

---@class ___plugin_name___.kit.LSP.SemanticTokensDeltaParams
---@field public textDocument ___plugin_name___.kit.LSP.TextDocumentIdentifier
---@field public previousResultId string

---@class ___plugin_name___.kit.LSP.SemanticTokensDelta
---@field public resultId string
---@field public edits ___plugin_name___.kit.LSP.SemanticTokensEdit[]

---@class ___plugin_name___.kit.LSP.SemanticTokensDeltaPartialResult
---@field public edits ___plugin_name___.kit.LSP.SemanticTokensEdit[]

---@class ___plugin_name___.kit.LSP.SemanticTokensRangeParams
---@field public textDocument ___plugin_name___.kit.LSP.TextDocumentIdentifier
---@field public range ___plugin_name___.kit.LSP.Range

---@class ___plugin_name___.kit.LSP.ShowDocumentParams
---@field public uri string
---@field public external boolean
---@field public takeFocus boolean
---@field public selection ___plugin_name___.kit.LSP.Range

---@class ___plugin_name___.kit.LSP.ShowDocumentResult
---@field public success boolean

---@class ___plugin_name___.kit.LSP.LinkedEditingRangeParams : ___plugin_name___.kit.LSP.TextDocumentPositionParams

---@class ___plugin_name___.kit.LSP.LinkedEditingRanges
---@field public ranges ___plugin_name___.kit.LSP.Range[]
---@field public wordPattern string

---@class ___plugin_name___.kit.LSP.LinkedEditingRangeRegistrationOptions : ___plugin_name___.kit.LSP.TextDocumentRegistrationOptions

---@class ___plugin_name___.kit.LSP.CreateFilesParams
---@field public files ___plugin_name___.kit.LSP.FileCreate[]

---@class ___plugin_name___.kit.LSP.WorkspaceEdit
---@field public changes table<string, ___plugin_name___.kit.LSP.TextEdit[]>
---@field public documentChanges (___plugin_name___.kit.LSP.TextDocumentEdit | ___plugin_name___.kit.LSP.CreateFile | ___plugin_name___.kit.LSP.RenameFile | ___plugin_name___.kit.LSP.DeleteFile)[]
---@field public changeAnnotations table<___plugin_name___.kit.LSP.ChangeAnnotationIdentifier, ___plugin_name___.kit.LSP.ChangeAnnotation>

---@class ___plugin_name___.kit.LSP.FileOperationRegistrationOptions
---@field public filters ___plugin_name___.kit.LSP.FileOperationFilter[]

---@class ___plugin_name___.kit.LSP.RenameFilesParams
---@field public files ___plugin_name___.kit.LSP.FileRename[]

---@class ___plugin_name___.kit.LSP.DeleteFilesParams
---@field public files ___plugin_name___.kit.LSP.FileDelete[]

---@class ___plugin_name___.kit.LSP.MonikerParams : ___plugin_name___.kit.LSP.TextDocumentPositionParams

---@class ___plugin_name___.kit.LSP.Moniker
---@field public scheme string
---@field public identifier string
---@field public unique ___plugin_name___.kit.LSP.UniquenessLevel
---@field public kind ___plugin_name___.kit.LSP.MonikerKind

---@class ___plugin_name___.kit.LSP.MonikerRegistrationOptions : ___plugin_name___.kit.LSP.TextDocumentRegistrationOptions

---@class ___plugin_name___.kit.LSP.TypeHierarchyPrepareParams : ___plugin_name___.kit.LSP.TextDocumentPositionParams

---@class ___plugin_name___.kit.LSP.TypeHierarchyItem
---@field public name string
---@field public kind ___plugin_name___.kit.LSP.SymbolKind
---@field public tags ___plugin_name___.kit.LSP.SymbolTag[]
---@field public detail string
---@field public uri string
---@field public range ___plugin_name___.kit.LSP.Range
---@field public selectionRange ___plugin_name___.kit.LSP.Range
---@field public data ___plugin_name___.kit.LSP.LSPAny

---@class ___plugin_name___.kit.LSP.TypeHierarchyRegistrationOptions : ___plugin_name___.kit.LSP.TextDocumentRegistrationOptions

---@class ___plugin_name___.kit.LSP.TypeHierarchySupertypesParams
---@field public item ___plugin_name___.kit.LSP.TypeHierarchyItem

---@class ___plugin_name___.kit.LSP.TypeHierarchySubtypesParams
---@field public item ___plugin_name___.kit.LSP.TypeHierarchyItem

---@class ___plugin_name___.kit.LSP.InlineValueParams
---@field public textDocument ___plugin_name___.kit.LSP.TextDocumentIdentifier
---@field public range ___plugin_name___.kit.LSP.Range
---@field public context ___plugin_name___.kit.LSP.InlineValueContext

---@class ___plugin_name___.kit.LSP.InlineValueRegistrationOptions : ___plugin_name___.kit.LSP.InlineValueOptions

---@class ___plugin_name___.kit.LSP.InlayHintParams
---@field public textDocument ___plugin_name___.kit.LSP.TextDocumentIdentifier
---@field public range ___plugin_name___.kit.LSP.Range

---@class ___plugin_name___.kit.LSP.InlayHint
---@field public position ___plugin_name___.kit.LSP.Position
---@field public label (string | ___plugin_name___.kit.LSP.InlayHintLabelPart[])
---@field public kind ___plugin_name___.kit.LSP.InlayHintKind
---@field public textEdits ___plugin_name___.kit.LSP.TextEdit[]
---@field public tooltip (string | ___plugin_name___.kit.LSP.MarkupContent)
---@field public paddingLeft boolean
---@field public paddingRight boolean
---@field public data ___plugin_name___.kit.LSP.LSPAny

---@class ___plugin_name___.kit.LSP.InlayHintRegistrationOptions : ___plugin_name___.kit.LSP.InlayHintOptions

---@class ___plugin_name___.kit.LSP.DocumentDiagnosticParams
---@field public textDocument ___plugin_name___.kit.LSP.TextDocumentIdentifier
---@field public identifier string
---@field public previousResultId string

---@class ___plugin_name___.kit.LSP.DocumentDiagnosticReportPartialResult
---@field public relatedDocuments table<string, (___plugin_name___.kit.LSP.FullDocumentDiagnosticReport | ___plugin_name___.kit.LSP.UnchangedDocumentDiagnosticReport)>

---@class ___plugin_name___.kit.LSP.DiagnosticServerCancellationData
---@field public retriggerRequest boolean

---@class ___plugin_name___.kit.LSP.DiagnosticRegistrationOptions : ___plugin_name___.kit.LSP.TextDocumentRegistrationOptions

---@class ___plugin_name___.kit.LSP.WorkspaceDiagnosticParams
---@field public identifier string
---@field public previousResultIds ___plugin_name___.kit.LSP.PreviousResultId[]

---@class ___plugin_name___.kit.LSP.WorkspaceDiagnosticReport
---@field public items ___plugin_name___.kit.LSP.WorkspaceDocumentDiagnosticReport[]

---@class ___plugin_name___.kit.LSP.WorkspaceDiagnosticReportPartialResult
---@field public items ___plugin_name___.kit.LSP.WorkspaceDocumentDiagnosticReport[]

---@class ___plugin_name___.kit.LSP.DidOpenNotebookDocumentParams
---@field public notebookDocument ___plugin_name___.kit.LSP.NotebookDocument
---@field public cellTextDocuments ___plugin_name___.kit.LSP.TextDocumentItem[]

---@class ___plugin_name___.kit.LSP.DidChangeNotebookDocumentParams
---@field public notebookDocument ___plugin_name___.kit.LSP.VersionedNotebookDocumentIdentifier
---@field public change ___plugin_name___.kit.LSP.NotebookDocumentChangeEvent

---@class ___plugin_name___.kit.LSP.DidSaveNotebookDocumentParams
---@field public notebookDocument ___plugin_name___.kit.LSP.NotebookDocumentIdentifier

---@class ___plugin_name___.kit.LSP.DidCloseNotebookDocumentParams
---@field public notebookDocument ___plugin_name___.kit.LSP.NotebookDocumentIdentifier
---@field public cellTextDocuments ___plugin_name___.kit.LSP.TextDocumentIdentifier[]

---@class ___plugin_name___.kit.LSP.RegistrationParams
---@field public registrations ___plugin_name___.kit.LSP.Registration[]

---@class ___plugin_name___.kit.LSP.UnregistrationParams
---@field public unregisterations ___plugin_name___.kit.LSP.Unregistration[]

---@class ___plugin_name___.kit.LSP.InitializeParams : ___plugin_name___.kit.LSP._InitializeParams

---@class ___plugin_name___.kit.LSP.InitializeResult
---@field public capabilities ___plugin_name___.kit.LSP.ServerCapabilities
---@field public serverInfo { name: string, version?: string }

---@class ___plugin_name___.kit.LSP.InitializeError
---@field public retry boolean

---@class ___plugin_name___.kit.LSP.InitializedParams

---@class ___plugin_name___.kit.LSP.DidChangeConfigurationParams
---@field public settings ___plugin_name___.kit.LSP.LSPAny

---@class ___plugin_name___.kit.LSP.DidChangeConfigurationRegistrationOptions
---@field public section (string | string[])

---@class ___plugin_name___.kit.LSP.ShowMessageParams
---@field public type ___plugin_name___.kit.LSP.MessageType
---@field public message string

---@class ___plugin_name___.kit.LSP.ShowMessageRequestParams
---@field public type ___plugin_name___.kit.LSP.MessageType
---@field public message string
---@field public actions ___plugin_name___.kit.LSP.MessageActionItem[]

---@class ___plugin_name___.kit.LSP.MessageActionItem
---@field public title string

---@class ___plugin_name___.kit.LSP.LogMessageParams
---@field public type ___plugin_name___.kit.LSP.MessageType
---@field public message string

---@class ___plugin_name___.kit.LSP.DidOpenTextDocumentParams
---@field public textDocument ___plugin_name___.kit.LSP.TextDocumentItem

---@class ___plugin_name___.kit.LSP.DidChangeTextDocumentParams
---@field public textDocument ___plugin_name___.kit.LSP.VersionedTextDocumentIdentifier
---@field public contentChanges ___plugin_name___.kit.LSP.TextDocumentContentChangeEvent[]

---@class ___plugin_name___.kit.LSP.TextDocumentChangeRegistrationOptions : ___plugin_name___.kit.LSP.TextDocumentRegistrationOptions
---@field public syncKind ___plugin_name___.kit.LSP.TextDocumentSyncKind

---@class ___plugin_name___.kit.LSP.DidCloseTextDocumentParams
---@field public textDocument ___plugin_name___.kit.LSP.TextDocumentIdentifier

---@class ___plugin_name___.kit.LSP.DidSaveTextDocumentParams
---@field public textDocument ___plugin_name___.kit.LSP.TextDocumentIdentifier
---@field public text string

---@class ___plugin_name___.kit.LSP.TextDocumentSaveRegistrationOptions : ___plugin_name___.kit.LSP.TextDocumentRegistrationOptions

---@class ___plugin_name___.kit.LSP.WillSaveTextDocumentParams
---@field public textDocument ___plugin_name___.kit.LSP.TextDocumentIdentifier
---@field public reason ___plugin_name___.kit.LSP.TextDocumentSaveReason

---@class ___plugin_name___.kit.LSP.TextEdit
---@field public range ___plugin_name___.kit.LSP.Range
---@field public newText string

---@class ___plugin_name___.kit.LSP.DidChangeWatchedFilesParams
---@field public changes ___plugin_name___.kit.LSP.FileEvent[]

---@class ___plugin_name___.kit.LSP.DidChangeWatchedFilesRegistrationOptions
---@field public watchers ___plugin_name___.kit.LSP.FileSystemWatcher[]

---@class ___plugin_name___.kit.LSP.PublishDiagnosticsParams
---@field public uri string
---@field public version integer
---@field public diagnostics ___plugin_name___.kit.LSP.Diagnostic[]

---@class ___plugin_name___.kit.LSP.CompletionParams : ___plugin_name___.kit.LSP.TextDocumentPositionParams
---@field public context ___plugin_name___.kit.LSP.CompletionContext

---@class ___plugin_name___.kit.LSP.CompletionItem
---@field public label string
---@field public labelDetails ___plugin_name___.kit.LSP.CompletionItemLabelDetails
---@field public kind ___plugin_name___.kit.LSP.CompletionItemKind
---@field public tags ___plugin_name___.kit.LSP.CompletionItemTag[]
---@field public detail string
---@field public documentation (string | ___plugin_name___.kit.LSP.MarkupContent)
---@field public deprecated boolean
---@field public preselect boolean
---@field public sortText string
---@field public filterText string
---@field public insertText string
---@field public insertTextFormat ___plugin_name___.kit.LSP.InsertTextFormat
---@field public insertTextMode ___plugin_name___.kit.LSP.InsertTextMode
---@field public textEdit (___plugin_name___.kit.LSP.TextEdit | ___plugin_name___.kit.LSP.InsertReplaceEdit)
---@field public textEditText string
---@field public additionalTextEdits ___plugin_name___.kit.LSP.TextEdit[]
---@field public commitCharacters string[]
---@field public command ___plugin_name___.kit.LSP.Command
---@field public data ___plugin_name___.kit.LSP.LSPAny

---@class ___plugin_name___.kit.LSP.CompletionList
---@field public isIncomplete boolean
---@field public itemDefaults { commitCharacters?: string[], editRange?: (___plugin_name___.kit.LSP.Range | { insert: ___plugin_name___.kit.LSP.Range, replace: ___plugin_name___.kit.LSP.Range }), insertTextFormat?: ___plugin_name___.kit.LSP.InsertTextFormat, insertTextMode?: ___plugin_name___.kit.LSP.InsertTextMode, data?: ___plugin_name___.kit.LSP.LSPAny }
---@field public items ___plugin_name___.kit.LSP.CompletionItem[]

---@class ___plugin_name___.kit.LSP.CompletionRegistrationOptions : ___plugin_name___.kit.LSP.TextDocumentRegistrationOptions

---@class ___plugin_name___.kit.LSP.HoverParams : ___plugin_name___.kit.LSP.TextDocumentPositionParams

---@class ___plugin_name___.kit.LSP.Hover
---@field public contents (___plugin_name___.kit.LSP.MarkupContent | ___plugin_name___.kit.LSP.MarkedString | ___plugin_name___.kit.LSP.MarkedString[])
---@field public range ___plugin_name___.kit.LSP.Range

---@class ___plugin_name___.kit.LSP.HoverRegistrationOptions : ___plugin_name___.kit.LSP.TextDocumentRegistrationOptions

---@class ___plugin_name___.kit.LSP.SignatureHelpParams : ___plugin_name___.kit.LSP.TextDocumentPositionParams
---@field public context ___plugin_name___.kit.LSP.SignatureHelpContext

---@class ___plugin_name___.kit.LSP.SignatureHelp
---@field public signatures ___plugin_name___.kit.LSP.SignatureInformation[]
---@field public activeSignature integer
---@field public activeParameter integer

---@class ___plugin_name___.kit.LSP.SignatureHelpRegistrationOptions : ___plugin_name___.kit.LSP.TextDocumentRegistrationOptions

---@class ___plugin_name___.kit.LSP.DefinitionParams : ___plugin_name___.kit.LSP.TextDocumentPositionParams

---@class ___plugin_name___.kit.LSP.DefinitionRegistrationOptions : ___plugin_name___.kit.LSP.TextDocumentRegistrationOptions

---@class ___plugin_name___.kit.LSP.ReferenceParams : ___plugin_name___.kit.LSP.TextDocumentPositionParams
---@field public context ___plugin_name___.kit.LSP.ReferenceContext

---@class ___plugin_name___.kit.LSP.ReferenceRegistrationOptions : ___plugin_name___.kit.LSP.TextDocumentRegistrationOptions

---@class ___plugin_name___.kit.LSP.DocumentHighlightParams : ___plugin_name___.kit.LSP.TextDocumentPositionParams

---@class ___plugin_name___.kit.LSP.DocumentHighlight
---@field public range ___plugin_name___.kit.LSP.Range
---@field public kind ___plugin_name___.kit.LSP.DocumentHighlightKind

---@class ___plugin_name___.kit.LSP.DocumentHighlightRegistrationOptions : ___plugin_name___.kit.LSP.TextDocumentRegistrationOptions

---@class ___plugin_name___.kit.LSP.DocumentSymbolParams
---@field public textDocument ___plugin_name___.kit.LSP.TextDocumentIdentifier

---@class ___plugin_name___.kit.LSP.SymbolInformation : ___plugin_name___.kit.LSP.BaseSymbolInformation
---@field public deprecated boolean
---@field public location ___plugin_name___.kit.LSP.Location

---@class ___plugin_name___.kit.LSP.DocumentSymbol
---@field public name string
---@field public detail string
---@field public kind ___plugin_name___.kit.LSP.SymbolKind
---@field public tags ___plugin_name___.kit.LSP.SymbolTag[]
---@field public deprecated boolean
---@field public range ___plugin_name___.kit.LSP.Range
---@field public selectionRange ___plugin_name___.kit.LSP.Range
---@field public children ___plugin_name___.kit.LSP.DocumentSymbol[]

---@class ___plugin_name___.kit.LSP.DocumentSymbolRegistrationOptions : ___plugin_name___.kit.LSP.TextDocumentRegistrationOptions

---@class ___plugin_name___.kit.LSP.CodeActionParams
---@field public textDocument ___plugin_name___.kit.LSP.TextDocumentIdentifier
---@field public range ___plugin_name___.kit.LSP.Range
---@field public context ___plugin_name___.kit.LSP.CodeActionContext

---@class ___plugin_name___.kit.LSP.Command
---@field public title string
---@field public command string
---@field public arguments ___plugin_name___.kit.LSP.LSPAny[]

---@class ___plugin_name___.kit.LSP.CodeAction
---@field public title string
---@field public kind ___plugin_name___.kit.LSP.CodeActionKind
---@field public diagnostics ___plugin_name___.kit.LSP.Diagnostic[]
---@field public isPreferred boolean
---@field public disabled { reason: string }
---@field public edit ___plugin_name___.kit.LSP.WorkspaceEdit
---@field public command ___plugin_name___.kit.LSP.Command
---@field public data ___plugin_name___.kit.LSP.LSPAny

---@class ___plugin_name___.kit.LSP.CodeActionRegistrationOptions : ___plugin_name___.kit.LSP.TextDocumentRegistrationOptions

---@class ___plugin_name___.kit.LSP.WorkspaceSymbolParams
---@field public query string

---@class ___plugin_name___.kit.LSP.WorkspaceSymbol : ___plugin_name___.kit.LSP.BaseSymbolInformation
---@field public location (___plugin_name___.kit.LSP.Location | { uri: string })
---@field public data ___plugin_name___.kit.LSP.LSPAny

---@class ___plugin_name___.kit.LSP.WorkspaceSymbolRegistrationOptions : ___plugin_name___.kit.LSP.WorkspaceSymbolOptions

---@class ___plugin_name___.kit.LSP.CodeLensParams
---@field public textDocument ___plugin_name___.kit.LSP.TextDocumentIdentifier

---@class ___plugin_name___.kit.LSP.CodeLens
---@field public range ___plugin_name___.kit.LSP.Range
---@field public command ___plugin_name___.kit.LSP.Command
---@field public data ___plugin_name___.kit.LSP.LSPAny

---@class ___plugin_name___.kit.LSP.CodeLensRegistrationOptions : ___plugin_name___.kit.LSP.TextDocumentRegistrationOptions

---@class ___plugin_name___.kit.LSP.DocumentLinkParams
---@field public textDocument ___plugin_name___.kit.LSP.TextDocumentIdentifier

---@class ___plugin_name___.kit.LSP.DocumentLink
---@field public range ___plugin_name___.kit.LSP.Range
---@field public target string
---@field public tooltip string
---@field public data ___plugin_name___.kit.LSP.LSPAny

---@class ___plugin_name___.kit.LSP.DocumentLinkRegistrationOptions : ___plugin_name___.kit.LSP.TextDocumentRegistrationOptions

---@class ___plugin_name___.kit.LSP.DocumentFormattingParams
---@field public textDocument ___plugin_name___.kit.LSP.TextDocumentIdentifier
---@field public options ___plugin_name___.kit.LSP.FormattingOptions

---@class ___plugin_name___.kit.LSP.DocumentFormattingRegistrationOptions : ___plugin_name___.kit.LSP.TextDocumentRegistrationOptions

---@class ___plugin_name___.kit.LSP.DocumentRangeFormattingParams
---@field public textDocument ___plugin_name___.kit.LSP.TextDocumentIdentifier
---@field public range ___plugin_name___.kit.LSP.Range
---@field public options ___plugin_name___.kit.LSP.FormattingOptions

---@class ___plugin_name___.kit.LSP.DocumentRangeFormattingRegistrationOptions : ___plugin_name___.kit.LSP.TextDocumentRegistrationOptions

---@class ___plugin_name___.kit.LSP.DocumentOnTypeFormattingParams
---@field public textDocument ___plugin_name___.kit.LSP.TextDocumentIdentifier
---@field public position ___plugin_name___.kit.LSP.Position
---@field public ch string
---@field public options ___plugin_name___.kit.LSP.FormattingOptions

---@class ___plugin_name___.kit.LSP.DocumentOnTypeFormattingRegistrationOptions : ___plugin_name___.kit.LSP.TextDocumentRegistrationOptions

---@class ___plugin_name___.kit.LSP.RenameParams
---@field public textDocument ___plugin_name___.kit.LSP.TextDocumentIdentifier
---@field public position ___plugin_name___.kit.LSP.Position
---@field public newName string

---@class ___plugin_name___.kit.LSP.RenameRegistrationOptions : ___plugin_name___.kit.LSP.TextDocumentRegistrationOptions

---@class ___plugin_name___.kit.LSP.PrepareRenameParams : ___plugin_name___.kit.LSP.TextDocumentPositionParams

---@class ___plugin_name___.kit.LSP.ExecuteCommandParams
---@field public command string
---@field public arguments ___plugin_name___.kit.LSP.LSPAny[]

---@class ___plugin_name___.kit.LSP.ExecuteCommandRegistrationOptions : ___plugin_name___.kit.LSP.ExecuteCommandOptions

---@class ___plugin_name___.kit.LSP.ApplyWorkspaceEditParams
---@field public label string
---@field public edit ___plugin_name___.kit.LSP.WorkspaceEdit

---@class ___plugin_name___.kit.LSP.ApplyWorkspaceEditResult
---@field public applied boolean
---@field public failureReason string
---@field public failedChange integer

---@class ___plugin_name___.kit.LSP.WorkDoneProgressBegin
---@field public kind "begin"
---@field public title string
---@field public cancellable boolean
---@field public message string
---@field public percentage integer

---@class ___plugin_name___.kit.LSP.WorkDoneProgressReport
---@field public kind "report"
---@field public cancellable boolean
---@field public message string
---@field public percentage integer

---@class ___plugin_name___.kit.LSP.WorkDoneProgressEnd
---@field public kind "end"
---@field public message string

---@class ___plugin_name___.kit.LSP.SetTraceParams
---@field public value ___plugin_name___.kit.LSP.TraceValues

---@class ___plugin_name___.kit.LSP.LogTraceParams
---@field public message string
---@field public verbose string

---@class ___plugin_name___.kit.LSP.CancelParams
---@field public id (integer | string)

---@class ___plugin_name___.kit.LSP.ProgressParams
---@field public token ___plugin_name___.kit.LSP.ProgressToken
---@field public value ___plugin_name___.kit.LSP.LSPAny

---@class ___plugin_name___.kit.LSP.TextDocumentPositionParams
---@field public textDocument ___plugin_name___.kit.LSP.TextDocumentIdentifier
---@field public position ___plugin_name___.kit.LSP.Position

---@class ___plugin_name___.kit.LSP.WorkDoneProgressParams
---@field public workDoneToken ___plugin_name___.kit.LSP.ProgressToken

---@class ___plugin_name___.kit.LSP.LocationLink
---@field public originSelectionRange ___plugin_name___.kit.LSP.Range
---@field public targetUri string
---@field public targetRange ___plugin_name___.kit.LSP.Range
---@field public targetSelectionRange ___plugin_name___.kit.LSP.Range

---@class ___plugin_name___.kit.LSP.Range
---@field public start ___plugin_name___.kit.LSP.Position
---@field public end ___plugin_name___.kit.LSP.Position

---@class ___plugin_name___.kit.LSP.ImplementationOptions

---@class ___plugin_name___.kit.LSP.StaticRegistrationOptions
---@field public id string

---@class ___plugin_name___.kit.LSP.TypeDefinitionOptions

---@class ___plugin_name___.kit.LSP.WorkspaceFoldersChangeEvent
---@field public added ___plugin_name___.kit.LSP.WorkspaceFolder[]
---@field public removed ___plugin_name___.kit.LSP.WorkspaceFolder[]

---@class ___plugin_name___.kit.LSP.ConfigurationItem
---@field public scopeUri string
---@field public section string

---@class ___plugin_name___.kit.LSP.TextDocumentIdentifier
---@field public uri string

---@class ___plugin_name___.kit.LSP.Color
---@field public red integer
---@field public green integer
---@field public blue integer
---@field public alpha integer

---@class ___plugin_name___.kit.LSP.DocumentColorOptions

---@class ___plugin_name___.kit.LSP.FoldingRangeOptions

---@class ___plugin_name___.kit.LSP.DeclarationOptions

---@class ___plugin_name___.kit.LSP.Position
---@field public line integer
---@field public character integer

---@class ___plugin_name___.kit.LSP.SelectionRangeOptions

---@class ___plugin_name___.kit.LSP.CallHierarchyOptions

---@class ___plugin_name___.kit.LSP.SemanticTokensOptions
---@field public legend ___plugin_name___.kit.LSP.SemanticTokensLegend
---@field public range (boolean | {  })
---@field public full (boolean | { delta?: boolean })

---@class ___plugin_name___.kit.LSP.SemanticTokensEdit
---@field public start integer
---@field public deleteCount integer
---@field public data integer[]

---@class ___plugin_name___.kit.LSP.LinkedEditingRangeOptions

---@class ___plugin_name___.kit.LSP.FileCreate
---@field public uri string

---@class ___plugin_name___.kit.LSP.TextDocumentEdit
---@field public textDocument ___plugin_name___.kit.LSP.OptionalVersionedTextDocumentIdentifier
---@field public edits (___plugin_name___.kit.LSP.TextEdit | ___plugin_name___.kit.LSP.AnnotatedTextEdit)[]

---@class ___plugin_name___.kit.LSP.CreateFile : ___plugin_name___.kit.LSP.ResourceOperation
---@field public kind "create"
---@field public uri string
---@field public options ___plugin_name___.kit.LSP.CreateFileOptions

---@class ___plugin_name___.kit.LSP.RenameFile : ___plugin_name___.kit.LSP.ResourceOperation
---@field public kind "rename"
---@field public oldUri string
---@field public newUri string
---@field public options ___plugin_name___.kit.LSP.RenameFileOptions

---@class ___plugin_name___.kit.LSP.DeleteFile : ___plugin_name___.kit.LSP.ResourceOperation
---@field public kind "delete"
---@field public uri string
---@field public options ___plugin_name___.kit.LSP.DeleteFileOptions

---@class ___plugin_name___.kit.LSP.ChangeAnnotation
---@field public label string
---@field public needsConfirmation boolean
---@field public description string

---@class ___plugin_name___.kit.LSP.FileOperationFilter
---@field public scheme string
---@field public pattern ___plugin_name___.kit.LSP.FileOperationPattern

---@class ___plugin_name___.kit.LSP.FileRename
---@field public oldUri string
---@field public newUri string

---@class ___plugin_name___.kit.LSP.FileDelete
---@field public uri string

---@class ___plugin_name___.kit.LSP.MonikerOptions

---@class ___plugin_name___.kit.LSP.TypeHierarchyOptions

---@class ___plugin_name___.kit.LSP.InlineValueContext
---@field public frameId integer
---@field public stoppedLocation ___plugin_name___.kit.LSP.Range

---@class ___plugin_name___.kit.LSP.InlineValueText
---@field public range ___plugin_name___.kit.LSP.Range
---@field public text string

---@class ___plugin_name___.kit.LSP.InlineValueVariableLookup
---@field public range ___plugin_name___.kit.LSP.Range
---@field public variableName string
---@field public caseSensitiveLookup boolean

---@class ___plugin_name___.kit.LSP.InlineValueEvaluatableExpression
---@field public range ___plugin_name___.kit.LSP.Range
---@field public expression string

---@class ___plugin_name___.kit.LSP.InlineValueOptions

---@class ___plugin_name___.kit.LSP.InlayHintLabelPart
---@field public value string
---@field public tooltip (string | ___plugin_name___.kit.LSP.MarkupContent)
---@field public location ___plugin_name___.kit.LSP.Location
---@field public command ___plugin_name___.kit.LSP.Command

---@class ___plugin_name___.kit.LSP.MarkupContent
---@field public kind ___plugin_name___.kit.LSP.MarkupKind
---@field public value string

---@class ___plugin_name___.kit.LSP.InlayHintOptions
---@field public resolveProvider boolean

---@class ___plugin_name___.kit.LSP.RelatedFullDocumentDiagnosticReport : ___plugin_name___.kit.LSP.FullDocumentDiagnosticReport
---@field public relatedDocuments table<string, (___plugin_name___.kit.LSP.FullDocumentDiagnosticReport | ___plugin_name___.kit.LSP.UnchangedDocumentDiagnosticReport)>

---@class ___plugin_name___.kit.LSP.RelatedUnchangedDocumentDiagnosticReport : ___plugin_name___.kit.LSP.UnchangedDocumentDiagnosticReport
---@field public relatedDocuments table<string, (___plugin_name___.kit.LSP.FullDocumentDiagnosticReport | ___plugin_name___.kit.LSP.UnchangedDocumentDiagnosticReport)>

---@class ___plugin_name___.kit.LSP.FullDocumentDiagnosticReport
---@field public kind "full"
---@field public resultId string
---@field public items ___plugin_name___.kit.LSP.Diagnostic[]

---@class ___plugin_name___.kit.LSP.UnchangedDocumentDiagnosticReport
---@field public kind "unchanged"
---@field public resultId string

---@class ___plugin_name___.kit.LSP.DiagnosticOptions
---@field public identifier string
---@field public interFileDependencies boolean
---@field public workspaceDiagnostics boolean

---@class ___plugin_name___.kit.LSP.PreviousResultId
---@field public uri string
---@field public value string

---@class ___plugin_name___.kit.LSP.NotebookDocument
---@field public uri string
---@field public notebookType string
---@field public version integer
---@field public metadata ___plugin_name___.kit.LSP.LSPObject
---@field public cells ___plugin_name___.kit.LSP.NotebookCell[]

---@class ___plugin_name___.kit.LSP.TextDocumentItem
---@field public uri string
---@field public languageId string
---@field public version integer
---@field public text string

---@class ___plugin_name___.kit.LSP.VersionedNotebookDocumentIdentifier
---@field public version integer
---@field public uri string

---@class ___plugin_name___.kit.LSP.NotebookDocumentChangeEvent
---@field public metadata ___plugin_name___.kit.LSP.LSPObject
---@field public cells { structure?: { array: ___plugin_name___.kit.LSP.NotebookCellArrayChange, didOpen?: ___plugin_name___.kit.LSP.TextDocumentItem[], didClose?: ___plugin_name___.kit.LSP.TextDocumentIdentifier[] }, data?: ___plugin_name___.kit.LSP.NotebookCell[], textContent?: { document: ___plugin_name___.kit.LSP.VersionedTextDocumentIdentifier, changes: ___plugin_name___.kit.LSP.TextDocumentContentChangeEvent[] }[] }

---@class ___plugin_name___.kit.LSP.NotebookDocumentIdentifier
---@field public uri string

---@class ___plugin_name___.kit.LSP.Registration
---@field public id string
---@field public method string
---@field public registerOptions ___plugin_name___.kit.LSP.LSPAny

---@class ___plugin_name___.kit.LSP.Unregistration
---@field public id string
---@field public method string

---@class ___plugin_name___.kit.LSP._InitializeParams
---@field public processId (integer | nil)
---@field public clientInfo { name: string, version?: string }
---@field public locale string
---@field public rootPath (string | nil)
---@field public rootUri (string | nil)
---@field public capabilities ___plugin_name___.kit.LSP.ClientCapabilities
---@field public initializationOptions ___plugin_name___.kit.LSP.LSPAny
---@field public trace ("off" | "messages" | "compact" | "verbose")

---@class ___plugin_name___.kit.LSP.WorkspaceFoldersInitializeParams
---@field public workspaceFolders (___plugin_name___.kit.LSP.WorkspaceFolder[] | nil)

---@class ___plugin_name___.kit.LSP.ServerCapabilities
---@field public positionEncoding ___plugin_name___.kit.LSP.PositionEncodingKind
---@field public textDocumentSync (___plugin_name___.kit.LSP.TextDocumentSyncOptions | ___plugin_name___.kit.LSP.TextDocumentSyncKind)
---@field public notebookDocumentSync (___plugin_name___.kit.LSP.NotebookDocumentSyncOptions | ___plugin_name___.kit.LSP.NotebookDocumentSyncRegistrationOptions)
---@field public completionProvider ___plugin_name___.kit.LSP.CompletionOptions
---@field public hoverProvider (boolean | ___plugin_name___.kit.LSP.HoverOptions)
---@field public signatureHelpProvider ___plugin_name___.kit.LSP.SignatureHelpOptions
---@field public declarationProvider (boolean | ___plugin_name___.kit.LSP.DeclarationOptions | ___plugin_name___.kit.LSP.DeclarationRegistrationOptions)
---@field public definitionProvider (boolean | ___plugin_name___.kit.LSP.DefinitionOptions)
---@field public typeDefinitionProvider (boolean | ___plugin_name___.kit.LSP.TypeDefinitionOptions | ___plugin_name___.kit.LSP.TypeDefinitionRegistrationOptions)
---@field public implementationProvider (boolean | ___plugin_name___.kit.LSP.ImplementationOptions | ___plugin_name___.kit.LSP.ImplementationRegistrationOptions)
---@field public referencesProvider (boolean | ___plugin_name___.kit.LSP.ReferenceOptions)
---@field public documentHighlightProvider (boolean | ___plugin_name___.kit.LSP.DocumentHighlightOptions)
---@field public documentSymbolProvider (boolean | ___plugin_name___.kit.LSP.DocumentSymbolOptions)
---@field public codeActionProvider (boolean | ___plugin_name___.kit.LSP.CodeActionOptions)
---@field public codeLensProvider ___plugin_name___.kit.LSP.CodeLensOptions
---@field public documentLinkProvider ___plugin_name___.kit.LSP.DocumentLinkOptions
---@field public colorProvider (boolean | ___plugin_name___.kit.LSP.DocumentColorOptions | ___plugin_name___.kit.LSP.DocumentColorRegistrationOptions)
---@field public workspaceSymbolProvider (boolean | ___plugin_name___.kit.LSP.WorkspaceSymbolOptions)
---@field public documentFormattingProvider (boolean | ___plugin_name___.kit.LSP.DocumentFormattingOptions)
---@field public documentRangeFormattingProvider (boolean | ___plugin_name___.kit.LSP.DocumentRangeFormattingOptions)
---@field public documentOnTypeFormattingProvider ___plugin_name___.kit.LSP.DocumentOnTypeFormattingOptions
---@field public renameProvider (boolean | ___plugin_name___.kit.LSP.RenameOptions)
---@field public foldingRangeProvider (boolean | ___plugin_name___.kit.LSP.FoldingRangeOptions | ___plugin_name___.kit.LSP.FoldingRangeRegistrationOptions)
---@field public selectionRangeProvider (boolean | ___plugin_name___.kit.LSP.SelectionRangeOptions | ___plugin_name___.kit.LSP.SelectionRangeRegistrationOptions)
---@field public executeCommandProvider ___plugin_name___.kit.LSP.ExecuteCommandOptions
---@field public callHierarchyProvider (boolean | ___plugin_name___.kit.LSP.CallHierarchyOptions | ___plugin_name___.kit.LSP.CallHierarchyRegistrationOptions)
---@field public linkedEditingRangeProvider (boolean | ___plugin_name___.kit.LSP.LinkedEditingRangeOptions | ___plugin_name___.kit.LSP.LinkedEditingRangeRegistrationOptions)
---@field public semanticTokensProvider (___plugin_name___.kit.LSP.SemanticTokensOptions | ___plugin_name___.kit.LSP.SemanticTokensRegistrationOptions)
---@field public monikerProvider (boolean | ___plugin_name___.kit.LSP.MonikerOptions | ___plugin_name___.kit.LSP.MonikerRegistrationOptions)
---@field public typeHierarchyProvider (boolean | ___plugin_name___.kit.LSP.TypeHierarchyOptions | ___plugin_name___.kit.LSP.TypeHierarchyRegistrationOptions)
---@field public inlineValueProvider (boolean | ___plugin_name___.kit.LSP.InlineValueOptions | ___plugin_name___.kit.LSP.InlineValueRegistrationOptions)
---@field public inlayHintProvider (boolean | ___plugin_name___.kit.LSP.InlayHintOptions | ___plugin_name___.kit.LSP.InlayHintRegistrationOptions)
---@field public diagnosticProvider (___plugin_name___.kit.LSP.DiagnosticOptions | ___plugin_name___.kit.LSP.DiagnosticRegistrationOptions)
---@field public workspace { workspaceFolders?: ___plugin_name___.kit.LSP.WorkspaceFoldersServerCapabilities, fileOperations?: ___plugin_name___.kit.LSP.FileOperationOptions }
---@field public experimental ___plugin_name___.kit.LSP.LSPAny

---@class ___plugin_name___.kit.LSP.VersionedTextDocumentIdentifier : ___plugin_name___.kit.LSP.TextDocumentIdentifier
---@field public version integer

---@class ___plugin_name___.kit.LSP.SaveOptions
---@field public includeText boolean

---@class ___plugin_name___.kit.LSP.FileEvent
---@field public uri string
---@field public type ___plugin_name___.kit.LSP.FileChangeType

---@class ___plugin_name___.kit.LSP.FileSystemWatcher
---@field public globPattern ___plugin_name___.kit.LSP.GlobPattern
---@field public kind ___plugin_name___.kit.LSP.WatchKind

---@class ___plugin_name___.kit.LSP.Diagnostic
---@field public range ___plugin_name___.kit.LSP.Range
---@field public severity ___plugin_name___.kit.LSP.DiagnosticSeverity
---@field public code (integer | string)
---@field public codeDescription ___plugin_name___.kit.LSP.CodeDescription
---@field public source string
---@field public message string
---@field public tags ___plugin_name___.kit.LSP.DiagnosticTag[]
---@field public relatedInformation ___plugin_name___.kit.LSP.DiagnosticRelatedInformation[]
---@field public data ___plugin_name___.kit.LSP.LSPAny

---@class ___plugin_name___.kit.LSP.CompletionContext
---@field public triggerKind ___plugin_name___.kit.LSP.CompletionTriggerKind
---@field public triggerCharacter string

---@class ___plugin_name___.kit.LSP.CompletionItemLabelDetails
---@field public detail string
---@field public description string

---@class ___plugin_name___.kit.LSP.InsertReplaceEdit
---@field public newText string
---@field public insert ___plugin_name___.kit.LSP.Range
---@field public replace ___plugin_name___.kit.LSP.Range

---@class ___plugin_name___.kit.LSP.CompletionOptions
---@field public triggerCharacters string[]
---@field public allCommitCharacters string[]
---@field public resolveProvider boolean
---@field public completionItem { labelDetailsSupport?: boolean }

---@class ___plugin_name___.kit.LSP.HoverOptions

---@class ___plugin_name___.kit.LSP.SignatureHelpContext
---@field public triggerKind ___plugin_name___.kit.LSP.SignatureHelpTriggerKind
---@field public triggerCharacter string
---@field public isRetrigger boolean
---@field public activeSignatureHelp ___plugin_name___.kit.LSP.SignatureHelp

---@class ___plugin_name___.kit.LSP.SignatureInformation
---@field public label string
---@field public documentation (string | ___plugin_name___.kit.LSP.MarkupContent)
---@field public parameters ___plugin_name___.kit.LSP.ParameterInformation[]
---@field public activeParameter integer

---@class ___plugin_name___.kit.LSP.SignatureHelpOptions
---@field public triggerCharacters string[]
---@field public retriggerCharacters string[]

---@class ___plugin_name___.kit.LSP.DefinitionOptions

---@class ___plugin_name___.kit.LSP.ReferenceContext
---@field public includeDeclaration boolean

---@class ___plugin_name___.kit.LSP.ReferenceOptions

---@class ___plugin_name___.kit.LSP.DocumentHighlightOptions

---@class ___plugin_name___.kit.LSP.BaseSymbolInformation
---@field public name string
---@field public kind ___plugin_name___.kit.LSP.SymbolKind
---@field public tags ___plugin_name___.kit.LSP.SymbolTag[]
---@field public containerName string

---@class ___plugin_name___.kit.LSP.DocumentSymbolOptions
---@field public label string

---@class ___plugin_name___.kit.LSP.CodeActionContext
---@field public diagnostics ___plugin_name___.kit.LSP.Diagnostic[]
---@field public only ___plugin_name___.kit.LSP.CodeActionKind[]
---@field public triggerKind ___plugin_name___.kit.LSP.CodeActionTriggerKind

---@class ___plugin_name___.kit.LSP.CodeActionOptions
---@field public codeActionKinds ___plugin_name___.kit.LSP.CodeActionKind[]
---@field public resolveProvider boolean

---@class ___plugin_name___.kit.LSP.WorkspaceSymbolOptions
---@field public resolveProvider boolean

---@class ___plugin_name___.kit.LSP.CodeLensOptions
---@field public resolveProvider boolean

---@class ___plugin_name___.kit.LSP.DocumentLinkOptions
---@field public resolveProvider boolean

---@class ___plugin_name___.kit.LSP.FormattingOptions
---@field public tabSize integer
---@field public insertSpaces boolean
---@field public trimTrailingWhitespace boolean
---@field public insertFinalNewline boolean
---@field public trimFinalNewlines boolean

---@class ___plugin_name___.kit.LSP.DocumentFormattingOptions

---@class ___plugin_name___.kit.LSP.DocumentRangeFormattingOptions

---@class ___plugin_name___.kit.LSP.DocumentOnTypeFormattingOptions
---@field public firstTriggerCharacter string
---@field public moreTriggerCharacter string[]

---@class ___plugin_name___.kit.LSP.RenameOptions
---@field public prepareProvider boolean

---@class ___plugin_name___.kit.LSP.ExecuteCommandOptions
---@field public commands string[]

---@class ___plugin_name___.kit.LSP.SemanticTokensLegend
---@field public tokenTypes string[]
---@field public tokenModifiers string[]

---@class ___plugin_name___.kit.LSP.OptionalVersionedTextDocumentIdentifier : ___plugin_name___.kit.LSP.TextDocumentIdentifier
---@field public version (integer | nil)

---@class ___plugin_name___.kit.LSP.AnnotatedTextEdit : ___plugin_name___.kit.LSP.TextEdit
---@field public annotationId ___plugin_name___.kit.LSP.ChangeAnnotationIdentifier

---@class ___plugin_name___.kit.LSP.ResourceOperation
---@field public kind string
---@field public annotationId ___plugin_name___.kit.LSP.ChangeAnnotationIdentifier

---@class ___plugin_name___.kit.LSP.CreateFileOptions
---@field public overwrite boolean
---@field public ignoreIfExists boolean

---@class ___plugin_name___.kit.LSP.RenameFileOptions
---@field public overwrite boolean
---@field public ignoreIfExists boolean

---@class ___plugin_name___.kit.LSP.DeleteFileOptions
---@field public recursive boolean
---@field public ignoreIfNotExists boolean

---@class ___plugin_name___.kit.LSP.FileOperationPattern
---@field public glob string
---@field public matches ___plugin_name___.kit.LSP.FileOperationPatternKind
---@field public options ___plugin_name___.kit.LSP.FileOperationPatternOptions

---@class ___plugin_name___.kit.LSP.WorkspaceFullDocumentDiagnosticReport : ___plugin_name___.kit.LSP.FullDocumentDiagnosticReport
---@field public uri string
---@field public version (integer | nil)

---@class ___plugin_name___.kit.LSP.WorkspaceUnchangedDocumentDiagnosticReport : ___plugin_name___.kit.LSP.UnchangedDocumentDiagnosticReport
---@field public uri string
---@field public version (integer | nil)

---@class ___plugin_name___.kit.LSP.LSPObject

---@class ___plugin_name___.kit.LSP.NotebookCell
---@field public kind ___plugin_name___.kit.LSP.NotebookCellKind
---@field public document string
---@field public metadata ___plugin_name___.kit.LSP.LSPObject
---@field public executionSummary ___plugin_name___.kit.LSP.ExecutionSummary

---@class ___plugin_name___.kit.LSP.NotebookCellArrayChange
---@field public start integer
---@field public deleteCount integer
---@field public cells ___plugin_name___.kit.LSP.NotebookCell[]

---@class ___plugin_name___.kit.LSP.ClientCapabilities
---@field public workspace ___plugin_name___.kit.LSP.WorkspaceClientCapabilities
---@field public textDocument ___plugin_name___.kit.LSP.TextDocumentClientCapabilities
---@field public notebookDocument ___plugin_name___.kit.LSP.NotebookDocumentClientCapabilities
---@field public window ___plugin_name___.kit.LSP.WindowClientCapabilities
---@field public general ___plugin_name___.kit.LSP.GeneralClientCapabilities
---@field public experimental ___plugin_name___.kit.LSP.LSPAny

---@class ___plugin_name___.kit.LSP.TextDocumentSyncOptions
---@field public openClose boolean
---@field public change ___plugin_name___.kit.LSP.TextDocumentSyncKind
---@field public willSave boolean
---@field public willSaveWaitUntil boolean
---@field public save (boolean | ___plugin_name___.kit.LSP.SaveOptions)

---@class ___plugin_name___.kit.LSP.NotebookDocumentSyncOptions
---@field public notebookSelector ({ notebook: (string | ___plugin_name___.kit.LSP.NotebookDocumentFilter), cells?: { language: string }[] } | { notebook?: (string | ___plugin_name___.kit.LSP.NotebookDocumentFilter), cells: { language: string }[] })[]
---@field public save boolean

---@class ___plugin_name___.kit.LSP.NotebookDocumentSyncRegistrationOptions : ___plugin_name___.kit.LSP.NotebookDocumentSyncOptions

---@class ___plugin_name___.kit.LSP.WorkspaceFoldersServerCapabilities
---@field public supported boolean
---@field public changeNotifications (string | boolean)

---@class ___plugin_name___.kit.LSP.FileOperationOptions
---@field public didCreate ___plugin_name___.kit.LSP.FileOperationRegistrationOptions
---@field public willCreate ___plugin_name___.kit.LSP.FileOperationRegistrationOptions
---@field public didRename ___plugin_name___.kit.LSP.FileOperationRegistrationOptions
---@field public willRename ___plugin_name___.kit.LSP.FileOperationRegistrationOptions
---@field public didDelete ___plugin_name___.kit.LSP.FileOperationRegistrationOptions
---@field public willDelete ___plugin_name___.kit.LSP.FileOperationRegistrationOptions

---@class ___plugin_name___.kit.LSP.CodeDescription
---@field public href string

---@class ___plugin_name___.kit.LSP.DiagnosticRelatedInformation
---@field public location ___plugin_name___.kit.LSP.Location
---@field public message string

---@class ___plugin_name___.kit.LSP.ParameterInformation
---@field public label (string | (integer | integer)[])
---@field public documentation (string | ___plugin_name___.kit.LSP.MarkupContent)

---@class ___plugin_name___.kit.LSP.NotebookCellTextDocumentFilter
---@field public notebook (string | ___plugin_name___.kit.LSP.NotebookDocumentFilter)
---@field public language string

---@class ___plugin_name___.kit.LSP.FileOperationPatternOptions
---@field public ignoreCase boolean

---@class ___plugin_name___.kit.LSP.ExecutionSummary
---@field public executionOrder integer
---@field public success boolean

---@class ___plugin_name___.kit.LSP.WorkspaceClientCapabilities
---@field public applyEdit boolean
---@field public workspaceEdit ___plugin_name___.kit.LSP.WorkspaceEditClientCapabilities
---@field public didChangeConfiguration ___plugin_name___.kit.LSP.DidChangeConfigurationClientCapabilities
---@field public didChangeWatchedFiles ___plugin_name___.kit.LSP.DidChangeWatchedFilesClientCapabilities
---@field public symbol ___plugin_name___.kit.LSP.WorkspaceSymbolClientCapabilities
---@field public executeCommand ___plugin_name___.kit.LSP.ExecuteCommandClientCapabilities
---@field public workspaceFolders boolean
---@field public configuration boolean
---@field public semanticTokens ___plugin_name___.kit.LSP.SemanticTokensWorkspaceClientCapabilities
---@field public codeLens ___plugin_name___.kit.LSP.CodeLensWorkspaceClientCapabilities
---@field public fileOperations ___plugin_name___.kit.LSP.FileOperationClientCapabilities
---@field public inlineValue ___plugin_name___.kit.LSP.InlineValueWorkspaceClientCapabilities
---@field public inlayHint ___plugin_name___.kit.LSP.InlayHintWorkspaceClientCapabilities
---@field public diagnostics ___plugin_name___.kit.LSP.DiagnosticWorkspaceClientCapabilities

---@class ___plugin_name___.kit.LSP.TextDocumentClientCapabilities
---@field public synchronization ___plugin_name___.kit.LSP.TextDocumentSyncClientCapabilities
---@field public completion ___plugin_name___.kit.LSP.CompletionClientCapabilities
---@field public hover ___plugin_name___.kit.LSP.HoverClientCapabilities
---@field public signatureHelp ___plugin_name___.kit.LSP.SignatureHelpClientCapabilities
---@field public declaration ___plugin_name___.kit.LSP.DeclarationClientCapabilities
---@field public definition ___plugin_name___.kit.LSP.DefinitionClientCapabilities
---@field public typeDefinition ___plugin_name___.kit.LSP.TypeDefinitionClientCapabilities
---@field public implementation ___plugin_name___.kit.LSP.ImplementationClientCapabilities
---@field public references ___plugin_name___.kit.LSP.ReferenceClientCapabilities
---@field public documentHighlight ___plugin_name___.kit.LSP.DocumentHighlightClientCapabilities
---@field public documentSymbol ___plugin_name___.kit.LSP.DocumentSymbolClientCapabilities
---@field public codeAction ___plugin_name___.kit.LSP.CodeActionClientCapabilities
---@field public codeLens ___plugin_name___.kit.LSP.CodeLensClientCapabilities
---@field public documentLink ___plugin_name___.kit.LSP.DocumentLinkClientCapabilities
---@field public colorProvider ___plugin_name___.kit.LSP.DocumentColorClientCapabilities
---@field public formatting ___plugin_name___.kit.LSP.DocumentFormattingClientCapabilities
---@field public rangeFormatting ___plugin_name___.kit.LSP.DocumentRangeFormattingClientCapabilities
---@field public onTypeFormatting ___plugin_name___.kit.LSP.DocumentOnTypeFormattingClientCapabilities
---@field public rename ___plugin_name___.kit.LSP.RenameClientCapabilities
---@field public foldingRange ___plugin_name___.kit.LSP.FoldingRangeClientCapabilities
---@field public selectionRange ___plugin_name___.kit.LSP.SelectionRangeClientCapabilities
---@field public publishDiagnostics ___plugin_name___.kit.LSP.PublishDiagnosticsClientCapabilities
---@field public callHierarchy ___plugin_name___.kit.LSP.CallHierarchyClientCapabilities
---@field public semanticTokens ___plugin_name___.kit.LSP.SemanticTokensClientCapabilities
---@field public linkedEditingRange ___plugin_name___.kit.LSP.LinkedEditingRangeClientCapabilities
---@field public moniker ___plugin_name___.kit.LSP.MonikerClientCapabilities
---@field public typeHierarchy ___plugin_name___.kit.LSP.TypeHierarchyClientCapabilities
---@field public inlineValue ___plugin_name___.kit.LSP.InlineValueClientCapabilities
---@field public inlayHint ___plugin_name___.kit.LSP.InlayHintClientCapabilities
---@field public diagnostic ___plugin_name___.kit.LSP.DiagnosticClientCapabilities

---@class ___plugin_name___.kit.LSP.NotebookDocumentClientCapabilities
---@field public synchronization ___plugin_name___.kit.LSP.NotebookDocumentSyncClientCapabilities

---@class ___plugin_name___.kit.LSP.WindowClientCapabilities
---@field public workDoneProgress boolean
---@field public showMessage ___plugin_name___.kit.LSP.ShowMessageRequestClientCapabilities
---@field public showDocument ___plugin_name___.kit.LSP.ShowDocumentClientCapabilities

---@class ___plugin_name___.kit.LSP.GeneralClientCapabilities
---@field public staleRequestSupport { cancel: boolean, retryOnContentModified: string[] }
---@field public regularExpressions ___plugin_name___.kit.LSP.RegularExpressionsClientCapabilities
---@field public markdown ___plugin_name___.kit.LSP.MarkdownClientCapabilities
---@field public positionEncodings ___plugin_name___.kit.LSP.PositionEncodingKind[]

---@class ___plugin_name___.kit.LSP.RelativePattern
---@field public baseUri (___plugin_name___.kit.LSP.WorkspaceFolder | string)
---@field public pattern ___plugin_name___.kit.LSP.Pattern

---@class ___plugin_name___.kit.LSP.WorkspaceEditClientCapabilities
---@field public documentChanges boolean
---@field public resourceOperations ___plugin_name___.kit.LSP.ResourceOperationKind[]
---@field public failureHandling ___plugin_name___.kit.LSP.FailureHandlingKind
---@field public normalizesLineEndings boolean
---@field public changeAnnotationSupport { groupsOnLabel?: boolean }

---@class ___plugin_name___.kit.LSP.DidChangeConfigurationClientCapabilities
---@field public dynamicRegistration boolean

---@class ___plugin_name___.kit.LSP.DidChangeWatchedFilesClientCapabilities
---@field public dynamicRegistration boolean
---@field public relativePatternSupport boolean

---@class ___plugin_name___.kit.LSP.WorkspaceSymbolClientCapabilities
---@field public dynamicRegistration boolean
---@field public symbolKind { valueSet?: ___plugin_name___.kit.LSP.SymbolKind[] }
---@field public tagSupport { valueSet: ___plugin_name___.kit.LSP.SymbolTag[] }
---@field public resolveSupport { properties: string[] }

---@class ___plugin_name___.kit.LSP.ExecuteCommandClientCapabilities
---@field public dynamicRegistration boolean

---@class ___plugin_name___.kit.LSP.SemanticTokensWorkspaceClientCapabilities
---@field public refreshSupport boolean

---@class ___plugin_name___.kit.LSP.CodeLensWorkspaceClientCapabilities
---@field public refreshSupport boolean

---@class ___plugin_name___.kit.LSP.FileOperationClientCapabilities
---@field public dynamicRegistration boolean
---@field public didCreate boolean
---@field public willCreate boolean
---@field public didRename boolean
---@field public willRename boolean
---@field public didDelete boolean
---@field public willDelete boolean

---@class ___plugin_name___.kit.LSP.InlineValueWorkspaceClientCapabilities
---@field public refreshSupport boolean

---@class ___plugin_name___.kit.LSP.InlayHintWorkspaceClientCapabilities
---@field public refreshSupport boolean

---@class ___plugin_name___.kit.LSP.DiagnosticWorkspaceClientCapabilities
---@field public refreshSupport boolean

---@class ___plugin_name___.kit.LSP.TextDocumentSyncClientCapabilities
---@field public dynamicRegistration boolean
---@field public willSave boolean
---@field public willSaveWaitUntil boolean
---@field public didSave boolean

---@class ___plugin_name___.kit.LSP.CompletionClientCapabilities
---@field public dynamicRegistration boolean
---@field public completionItem { snippetSupport?: boolean, commitCharactersSupport?: boolean, documentationFormat?: ___plugin_name___.kit.LSP.MarkupKind[], deprecatedSupport?: boolean, preselectSupport?: boolean, tagSupport?: { valueSet: ___plugin_name___.kit.LSP.CompletionItemTag[] }, insertReplaceSupport?: boolean, resolveSupport?: { properties: string[] }, insertTextModeSupport?: { valueSet: ___plugin_name___.kit.LSP.InsertTextMode[] }, labelDetailsSupport?: boolean }
---@field public completionItemKind { valueSet?: ___plugin_name___.kit.LSP.CompletionItemKind[] }
---@field public insertTextMode ___plugin_name___.kit.LSP.InsertTextMode
---@field public contextSupport boolean
---@field public completionList { itemDefaults?: string[] }

---@class ___plugin_name___.kit.LSP.HoverClientCapabilities
---@field public dynamicRegistration boolean
---@field public contentFormat ___plugin_name___.kit.LSP.MarkupKind[]

---@class ___plugin_name___.kit.LSP.SignatureHelpClientCapabilities
---@field public dynamicRegistration boolean
---@field public signatureInformation { documentationFormat?: ___plugin_name___.kit.LSP.MarkupKind[], parameterInformation?: { labelOffsetSupport?: boolean }, activeParameterSupport?: boolean }
---@field public contextSupport boolean

---@class ___plugin_name___.kit.LSP.DeclarationClientCapabilities
---@field public dynamicRegistration boolean
---@field public linkSupport boolean

---@class ___plugin_name___.kit.LSP.DefinitionClientCapabilities
---@field public dynamicRegistration boolean
---@field public linkSupport boolean

---@class ___plugin_name___.kit.LSP.TypeDefinitionClientCapabilities
---@field public dynamicRegistration boolean
---@field public linkSupport boolean

---@class ___plugin_name___.kit.LSP.ImplementationClientCapabilities
---@field public dynamicRegistration boolean
---@field public linkSupport boolean

---@class ___plugin_name___.kit.LSP.ReferenceClientCapabilities
---@field public dynamicRegistration boolean

---@class ___plugin_name___.kit.LSP.DocumentHighlightClientCapabilities
---@field public dynamicRegistration boolean

---@class ___plugin_name___.kit.LSP.DocumentSymbolClientCapabilities
---@field public dynamicRegistration boolean
---@field public symbolKind { valueSet?: ___plugin_name___.kit.LSP.SymbolKind[] }
---@field public hierarchicalDocumentSymbolSupport boolean
---@field public tagSupport { valueSet: ___plugin_name___.kit.LSP.SymbolTag[] }
---@field public labelSupport boolean

---@class ___plugin_name___.kit.LSP.CodeActionClientCapabilities
---@field public dynamicRegistration boolean
---@field public codeActionLiteralSupport { codeActionKind: { valueSet: ___plugin_name___.kit.LSP.CodeActionKind[] } }
---@field public isPreferredSupport boolean
---@field public disabledSupport boolean
---@field public dataSupport boolean
---@field public resolveSupport { properties: string[] }
---@field public honorsChangeAnnotations boolean

---@class ___plugin_name___.kit.LSP.CodeLensClientCapabilities
---@field public dynamicRegistration boolean

---@class ___plugin_name___.kit.LSP.DocumentLinkClientCapabilities
---@field public dynamicRegistration boolean
---@field public tooltipSupport boolean

---@class ___plugin_name___.kit.LSP.DocumentColorClientCapabilities
---@field public dynamicRegistration boolean

---@class ___plugin_name___.kit.LSP.DocumentFormattingClientCapabilities
---@field public dynamicRegistration boolean

---@class ___plugin_name___.kit.LSP.DocumentRangeFormattingClientCapabilities
---@field public dynamicRegistration boolean

---@class ___plugin_name___.kit.LSP.DocumentOnTypeFormattingClientCapabilities
---@field public dynamicRegistration boolean

---@class ___plugin_name___.kit.LSP.RenameClientCapabilities
---@field public dynamicRegistration boolean
---@field public prepareSupport boolean
---@field public prepareSupportDefaultBehavior ___plugin_name___.kit.LSP.PrepareSupportDefaultBehavior
---@field public honorsChangeAnnotations boolean

---@class ___plugin_name___.kit.LSP.FoldingRangeClientCapabilities
---@field public dynamicRegistration boolean
---@field public rangeLimit integer
---@field public lineFoldingOnly boolean
---@field public foldingRangeKind { valueSet?: ___plugin_name___.kit.LSP.FoldingRangeKind[] }
---@field public foldingRange { collapsedText?: boolean }

---@class ___plugin_name___.kit.LSP.SelectionRangeClientCapabilities
---@field public dynamicRegistration boolean

---@class ___plugin_name___.kit.LSP.PublishDiagnosticsClientCapabilities
---@field public relatedInformation boolean
---@field public tagSupport { valueSet: ___plugin_name___.kit.LSP.DiagnosticTag[] }
---@field public versionSupport boolean
---@field public codeDescriptionSupport boolean
---@field public dataSupport boolean

---@class ___plugin_name___.kit.LSP.CallHierarchyClientCapabilities
---@field public dynamicRegistration boolean

---@class ___plugin_name___.kit.LSP.SemanticTokensClientCapabilities
---@field public dynamicRegistration boolean
---@field public requests { range?: (boolean | {  }), full?: (boolean | { delta?: boolean }) }
---@field public tokenTypes string[]
---@field public tokenModifiers string[]
---@field public formats ___plugin_name___.kit.LSP.TokenFormat[]
---@field public overlappingTokenSupport boolean
---@field public multilineTokenSupport boolean
---@field public serverCancelSupport boolean
---@field public augmentsSyntaxTokens boolean

---@class ___plugin_name___.kit.LSP.LinkedEditingRangeClientCapabilities
---@field public dynamicRegistration boolean

---@class ___plugin_name___.kit.LSP.MonikerClientCapabilities
---@field public dynamicRegistration boolean

---@class ___plugin_name___.kit.LSP.TypeHierarchyClientCapabilities
---@field public dynamicRegistration boolean

---@class ___plugin_name___.kit.LSP.InlineValueClientCapabilities
---@field public dynamicRegistration boolean

---@class ___plugin_name___.kit.LSP.InlayHintClientCapabilities
---@field public dynamicRegistration boolean
---@field public resolveSupport { properties: string[] }

---@class ___plugin_name___.kit.LSP.DiagnosticClientCapabilities
---@field public dynamicRegistration boolean
---@field public relatedDocumentSupport boolean

---@class ___plugin_name___.kit.LSP.NotebookDocumentSyncClientCapabilities
---@field public dynamicRegistration boolean
---@field public executionSummarySupport boolean

---@class ___plugin_name___.kit.LSP.ShowMessageRequestClientCapabilities
---@field public messageActionItem { additionalPropertiesSupport?: boolean }

---@class ___plugin_name___.kit.LSP.ShowDocumentClientCapabilities
---@field public support boolean

---@class ___plugin_name___.kit.LSP.RegularExpressionsClientCapabilities
---@field public engine string
---@field public version string

---@class ___plugin_name___.kit.LSP.MarkdownClientCapabilities
---@field public parser string
---@field public version string
---@field public allowedTags string[]

---@alias ___plugin_name___.kit.LSP.Definition (___plugin_name___.kit.LSP.Location | ___plugin_name___.kit.LSP.Location[])

---@alias ___plugin_name___.kit.LSP.DefinitionLink ___plugin_name___.kit.LSP.LocationLink

---@alias ___plugin_name___.kit.LSP.LSPArray ___plugin_name___.kit.LSP.LSPAny[]

---@alias ___plugin_name___.kit.LSP.LSPAny (___plugin_name___.kit.LSP.LSPObject | ___plugin_name___.kit.LSP.LSPArray | string | integer | integer | integer | boolean | nil)

---@alias ___plugin_name___.kit.LSP.Declaration (___plugin_name___.kit.LSP.Location | ___plugin_name___.kit.LSP.Location[])

---@alias ___plugin_name___.kit.LSP.DeclarationLink ___plugin_name___.kit.LSP.LocationLink

---@alias ___plugin_name___.kit.LSP.InlineValue (___plugin_name___.kit.LSP.InlineValueText | ___plugin_name___.kit.LSP.InlineValueVariableLookup | ___plugin_name___.kit.LSP.InlineValueEvaluatableExpression)

---@alias ___plugin_name___.kit.LSP.DocumentDiagnosticReport (___plugin_name___.kit.LSP.RelatedFullDocumentDiagnosticReport | ___plugin_name___.kit.LSP.RelatedUnchangedDocumentDiagnosticReport)

---@alias ___plugin_name___.kit.LSP.PrepareRenameResult (___plugin_name___.kit.LSP.Range | { range: ___plugin_name___.kit.LSP.Range, placeholder: string } | { defaultBehavior: boolean })

---@alias ___plugin_name___.kit.LSP.ProgressToken (integer | string)

---@alias ___plugin_name___.kit.LSP.DocumentSelector ___plugin_name___.kit.LSP.DocumentFilter[]

---@alias ___plugin_name___.kit.LSP.ChangeAnnotationIdentifier string

---@alias ___plugin_name___.kit.LSP.WorkspaceDocumentDiagnosticReport (___plugin_name___.kit.LSP.WorkspaceFullDocumentDiagnosticReport | ___plugin_name___.kit.LSP.WorkspaceUnchangedDocumentDiagnosticReport)

---@alias ___plugin_name___.kit.LSP.TextDocumentContentChangeEvent ({ range: ___plugin_name___.kit.LSP.Range, rangeLength?: integer, text: string } | { text: string })

---@alias ___plugin_name___.kit.LSP.MarkedString (string | { language: string, value: string })

---@alias ___plugin_name___.kit.LSP.DocumentFilter (___plugin_name___.kit.LSP.TextDocumentFilter | ___plugin_name___.kit.LSP.NotebookCellTextDocumentFilter)

---@alias ___plugin_name___.kit.LSP.GlobPattern (___plugin_name___.kit.LSP.Pattern | ___plugin_name___.kit.LSP.RelativePattern)

---@alias ___plugin_name___.kit.LSP.TextDocumentFilter ({ language: string, scheme?: string, pattern?: string } | { language?: string, scheme: string, pattern?: string } | { language?: string, scheme?: string, pattern: string })

---@alias ___plugin_name___.kit.LSP.NotebookDocumentFilter ({ notebookType: string, scheme?: string, pattern?: string } | { notebookType?: string, scheme: string, pattern?: string } | { notebookType?: string, scheme?: string, pattern: string })

---@alias ___plugin_name___.kit.LSP.Pattern string

return LSP
