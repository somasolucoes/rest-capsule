unit SomaCapsulas.REST.Source.Builder.Request;

interface

uses
  System.Classes, System.SysUtils, SomaCapsulas.REST.Interfaces, SomaCapsulas.REST.TTypes,
  System.Generics.Collections, REST.Types;

type
  TRESTRequestBuilder = class(TInterfacedObject, IRESTRequestBuilder)
  private
    FResquest: IRESTRequest;
  public
    function OnBaseURL(ABaseURL: string): IRESTRequestBuilder;
    function AtEndPoint(AEndPoint: string): IRESTRequestBuilder;
    function UsingQueryParams(AQueryParams: TDictionary<TQueryParamKey, TQueryParamValue>): IRESTRequestBuilder;
    function WithHeaders(AHeaders: TDictionary<THeaderKey, THeaderValue>): IRESTRequestBuilder;
    function WithBody(ABody: string): IRESTRequestBuilder;
    function WithContentType(AContentType: TRESTContentType): IRESTRequestBuilder;
    function UsingMethod(AMethod: TRESTRequestMethod): IRESTRequestBuilder;
    function Build: IRESTRequest;
    constructor Create;
  end;

implementation

uses
  SomaCapsulas.REST.Source.Request, Math;

{ TRESTRequestBuilder }

constructor TRESTRequestBuilder.Create;
begin
  Self.FResquest := TRequest.Create;
end;

function TRESTRequestBuilder.Build: IRESTRequest;
begin
  Result := Self.FResquest;
end;

function TRESTRequestBuilder.AtEndPoint(AEndPoint: string): IRESTRequestBuilder;
begin
  Self.FResquest.EndPoint := AEndPoint;
  Result := Self;
end;

function TRESTRequestBuilder.OnBaseURL(ABaseURL: string): IRESTRequestBuilder;
begin
  Self.FResquest.BaseURL := ABaseURL;
  Result := Self;
end;

function TRESTRequestBuilder.UsingMethod(
  AMethod: TRESTRequestMethod): IRESTRequestBuilder;
begin
  Self.FResquest.Method := AMethod;
  Result := Self;
end;

function TRESTRequestBuilder.UsingQueryParams(
  AQueryParams: TDictionary<TQueryParamKey, TQueryParamValue>): IRESTRequestBuilder;
var
  LQueryParamsKeys: TArray<TQueryParamKey>;
  LQueryParamsValues: TArray<TQueryParamValue>;
  I, LQueryParamsCount: Integer;
begin
  if Assigned(AQueryParams) then
  begin
    LQueryParamsKeys := AQueryParams.Keys.ToArray;
    LQueryParamsValues := AQueryParams.Values.ToArray;
    LQueryParamsCount := AQueryParams.Count;
    for I := ZeroValue to Pred(LQueryParamsCount) do
    begin
      Self.FResquest.QueryParams.AddOrSetValue(LQueryParamsKeys[I],
                                               LQueryParamsValues[I]);
    end;
  end;
  Result := Self;
end;

function TRESTRequestBuilder.WithBody(ABody: string): IRESTRequestBuilder;
begin
  Self.FResquest.Body := ABody;
  Result := Self;
end;

function TRESTRequestBuilder.WithContentType(
  AContentType: TRESTContentType): IRESTRequestBuilder;
begin
  Self.FResquest.ContentType := AContentType;
  Result := Self;
end;

function TRESTRequestBuilder.WithHeaders(
  AHeaders: TDictionary<THeaderKey, THeaderValue>): IRESTRequestBuilder;
var
  LHeadersKeys: TArray<THeaderKey>;
  LHeadersValues: TArray<THeaderValue>;
  I, LHeadersCount: Integer;
begin
  if Assigned(AHeaders) then
  begin
    LHeadersKeys := AHeaders.Keys.ToArray;
    LHeadersValues := AHeaders.Values.ToArray;
    LHeadersCount := AHeaders.Count;
    for I := ZeroValue to Pred(LHeadersCount) do
    begin
      Self.FResquest.Headers.AddOrSetValue(LHeadersKeys[I],
                                           LHeadersValues[I]);
    end;
  end;
  Result := Self;
end;

end.
