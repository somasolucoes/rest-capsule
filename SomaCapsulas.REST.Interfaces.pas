unit SomaCapsulas.REST.Interfaces;

interface

uses
  System.Classes, System.SysUtils, REST.Types, SomaCapsulas.REST.TTypes,
  System.Generics.Collections, SomaCapsulas.Log.Interfaces;

type
  IRESTRequest = interface
  ['{225BC517-1989-443F-AA59-28BFBE458D7B}']
    function GetBaseURL: string;
    function GetBody: string;
    function GetEndPoint: string;
    function GetMethod: TRESTRequestMethod;
    function GetQueryParams: TDictionary<TQueryParamKey, TQueryParamValue>;
    function GetQueryParamsKeys(I: Integer): TQueryParamKey;
    function GetQueryParamsValues(I: Integer): TQueryParamValue;
    function GetContentType: TRESTContentType;
    function GetURL: string;
    function GetURLWithParams: string;
    function GetHost: string;
    function GetHeaders: TDictionary<THeaderKey, THeaderValue>;
    function GetHeadersKeys(I: Integer): THeaderKey;
    function GetHeadersValues(I: Integer): THeaderValue;
    procedure SetContentType(const Value: TRESTContentType);
    procedure SetBaseURL(const Value: string);
    procedure SetBody(const Value: string);
    procedure SetEndPoint(const Value: string);
    procedure SetMethod(const Value: TRESTRequestMethod);
    procedure SetQueryParams(const Value: TDictionary<TQueryParamKey, TQueryParamValue>);
    procedure SetHeaders(const Value: TDictionary<THeaderKey, THeaderValue>);
    property QueryParams: TDictionary<TQueryParamKey, TQueryParamValue> read GetQueryParams write SetQueryParams;
    property QueryParamsKeys[I: Integer]: TQueryParamKey read GetQueryParamsKeys;
    property QueryParamsValues[I: Integer]: TQueryParamValue read GetQueryParamsValues;
    property Headers: TDictionary<THeaderKey, THeaderValue> read GetHeaders write SetHeaders;
    property HeadersKeys[I: Integer]: THeaderKey read GetHeadersKeys;
    property HeadersValues[I: Integer]: THeaderValue read GetHeadersValues;
    property BaseURL: string read GetBaseURL write SetBaseURL;
    property EndPoint: string read GetEndPoint write SetEndPoint;
    property Body: string read GetBody write SetBody;
    property Method: TRESTRequestMethod read GetMethod write SetMethod;
    property ContentType: TRESTContentType read GetContentType write SetContentType;
    property URL: string read GetURL;
    property URLWithParams: string read GetURLWithParams;
    property Host: string read GetHost;
  end;

  IRESTRequestBuilder = interface
  ['{814947C7-635D-484E-BDC3-71D3BCC699E9}']
    function OnBaseURL(ABaseURL: string): IRESTRequestBuilder;
    function AtEndPoint(AEndPoint: string): IRESTRequestBuilder;
    function UsingQueryParams(AQueryParams: TDictionary<TQueryParamKey, TQueryParamValue>): IRESTRequestBuilder;
    function WithHeaders(AHeaders: TDictionary<THeaderKey, THeaderValue>): IRESTRequestBuilder;
    function WithBody(ABody: string): IRESTRequestBuilder;
    function WithContentType(AContentType: TRESTContentType): IRESTRequestBuilder;
    function UsingMethod(AMethod: TRESTRequestMethod): IRESTRequestBuilder;
    function Build: IRESTRequest;
  end;

  IRESTResponseStatus = interface
  ['{68018481-9B65-4DA6-97CA-8ADEC65031F9}']
    function GetCode: Word;
    function GetText: string;
    procedure SetCode(const Value: Word);
    procedure SetText(const Value: string);
    property Code: Word read GetCode write SetCode;
    property Text: string read GetText write SetText;
  end;

  IRESTResponse = interface
  ['{EB7EF20B-E221-4049-9AE0-083AA838A9CB}']
    function GetBody: string;
    function GetStatus: IRESTResponseStatus;
    function GetContentType: TRESTContentType;
    procedure SetContentType(const Value: TRESTContentType);
    procedure SetBody(const Value: string);
    procedure SetStatus(const Value: IRESTResponseStatus);
    property Status: IRESTResponseStatus read GetStatus write SetStatus;
    property Body: string read GetBody write SetBody;
    property ContentType: TRESTContentType read GetContentType write SetContentType;
  end;

  IRESTClient = interface
  ['{77DED12B-6FF3-4790-AD93-7508E8C7DED7}']
    function ExecuteRequest(ARequest: IRESTRequest): IRESTResponse;
  end;

  IRESTClientIndyHTTPCommand = interface
  ['{1B221FAD-5EA0-41E9-A3C7-EA6D80A35801}']
    function Execute: string;
  end;

  IRESTFacade = interface
  ['{847B795E-2283-421A-B871-4A135D05FB94}']
    function GetOnRequestError: TProc<IRESTResponse>;
    function GetOnRequestSuccess: TProc<IRESTResponse>;
    function GetHasResponse: Boolean;
    function GetWasRequestSuccessful: Boolean;
    procedure SetOnRequestError(const Value: TProc<IRESTResponse>);
    procedure SetOnRequestSuccess(const Value: TProc<IRESTResponse>);
    property OnRequestSuccess: TProc<IRESTResponse> read GetOnRequestSuccess write SetOnRequestSuccess;
    property OnRequestError: TProc<IRESTResponse> read GetOnRequestError write SetOnRequestError;
    property HasResponse: Boolean read GetHasResponse;
    property WasRequestSuccessful: Boolean read GetWasRequestSuccessful;
    procedure PrepareRequest(AEndPoint, ABody: string; AContentType: TRESTContentType; AMethod: TRESTRequestMethod);
    procedure AddQueryParamRequest(AKey, AValue: string);
    procedure AddHeaderRequest(AKey, AValue: string);
    function ExecuteRequest: IRESTResponse;
    procedure GenerateLogResponse(ALogStrategy: ILogStrategy);
    procedure CleanQueryParams;
    procedure CleanRequest;
  end;

implementation end.
