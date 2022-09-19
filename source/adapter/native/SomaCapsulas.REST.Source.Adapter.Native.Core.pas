unit SomaCapsulas.REST.Source.Adapter.Native.Core;

interface

uses
  System.Classes, System.SysUtils, SomaCapsulas.REST.Source.Client, SomaCapsulas.REST.TTypes,
  SomaCapsulas.REST.Interfaces, REST.Types, Data.Bind.Components, Data.Bind.ObjectScope,
  REST.Client;

type
  TRESTClientNative = class(TRESTClientBase)
  private
    FClient: TRESTClient;
    FRequest: TRESTRequest;
    FResponse: TRESTResponse;
  protected
    procedure Reset;
    function RetrieveResponse: IRESTResponse;
  public
    function ExecuteRequest(ARequest: IRESTRequest; AFallback: TFunc<Exception, IRESTResponse> = nil): IRESTResponse; override;
    constructor Create;
    destructor Destroy; override;
  end;

implementation

uses
  Math, System.StrUtils, SomaCapsulas.REST.Source.Response, SomaCapsulas.REST.Constants;

{ TRESTClientNative }

constructor TRESTClientNative.Create;
begin
  Self.FClient := TRESTClient.Create(nil);
  Self.FResponse := TRESTResponse.Create(nil);
  Self.FRequest := TRESTRequest.Create(nil);
  Self.FRequest.Timeout := REST_REQUEST_TIMEOUT;
  Self.FRequest.Client := Self.FClient;
  Self.FRequest.Response := Self.FResponse;
  Reset;
end;

destructor TRESTClientNative.Destroy;
begin
  if Assigned(Self.FClient) then
    Self.FClient.Free;
  if Assigned(Self.FRequest) then
    Self.FRequest.Free;
  if Assigned(Self.FResponse) then
    Self.FResponse.Free;
  inherited;
end;

function TRESTClientNative.ExecuteRequest(ARequest: IRESTRequest;
  AFallback: TFunc<Exception, IRESTResponse>): IRESTResponse;
var
  I, LQueryParamsCount, LHeadersCount: ShortInt;
  LResponse, LFallbackResponse: IRESTResponse;
begin
  Reset;
  Result := nil;
  try
    Self.FClient.BaseURL   := ARequest.BaseURL;
    Self.FRequest.Resource := ARequest.EndPoint;
    Self.FRequest.Method   := ARequest.Method;
    if not ARequest.Body.IsEmpty then
      Self.FRequest.Body.Add(ARequest.Body, ARequest.ContentType);
    LQueryParamsCount := ARequest.QueryParams.Count;
    for I := ZeroValue to Pred(LQueryParamsCount) do
    begin
      Self.FRequest.AddParameter(ARequest.QueryParamsKeys[I],
                                 ARequest.QueryParamsValues[I],
                                 pkGETorPOST);
    end;
    LHeadersCount := ARequest.Headers.Count;
    for I := ZeroValue to Pred(LHeadersCount) do
    begin
      Self.FRequest.AddParameter(ARequest.HeadersKeys[I],
                                 ARequest.HeadersValues[I],
                                 pkHTTPHEADER);
    end;
    Self.FRequest.Execute;
    LResponse := RetrieveResponse;
    Result := LResponse;
  except
    on E: Exception do
    begin
      if not Assigned(AFallback) then
        raise;
      Reset;
      LFallbackResponse := AFallback(E);
      Result := LFallbackResponse;
    end;
  end;
end;

function TRESTClientNative.RetrieveResponse: IRESTResponse;
var
  LResponseBody: string;
  LContentType: TRESTContentType;
  LStatus: IRESTResponseStatus;
begin
  LContentType := ContentTypeFromString(Self.FResponse.ContentType);
  if LContentType in [ctAPPLICATION_JSON, ctAPPLICATION_XML] then
  begin
    LResponseBody := IfThen(Assigned(Self.FResponse.JSONValue),
                            Self.FResponse.JSONValue.ToString,
                            EmptyStr);
  end;
  LStatus := TResponseStatus.Create(Self.FResponse.StatusCode,
                                    Self.FResponse.StatusText);
  Result := TResponse.Create(LResponseBody, LContentType, LStatus);
end;

procedure TRESTClientNative.Reset;
begin
  Self.FClient.ResetToDefaults;
  Self.FRequest.ResetToDefaults;
  Self.FResponse.ResetToDefaults;
end;

end.
