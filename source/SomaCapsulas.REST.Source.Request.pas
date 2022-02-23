unit SomaCapsulas.REST.Source.Request;

interface

uses
  System.Classes, System.SysUtils, SomaCapsulas.REST.Interfaces, SomaCapsulas.REST.TTypes,
  SomaCapsulas.REST.Source.Builder.Request, System.Generics.Collections, REST.Types;

type
  TRequest = class(TInterfacedObject, IRESTRequest)
  strict private
    constructor Create;
  private
    FMethod: TRESTRequestMethod;
    FBody: string;
    FBaseURL: string;
    FQueryParams: TDictionary<TQueryParamKey, TQueryParamValue>;
    FEndPoint: string;
    FContentType: TRESTContentType;
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
    procedure SetBaseURL(const Value: string);
    procedure SetBody(const Value: string);
    procedure SetEndPoint(const Value: string);
    procedure SetMethod(const Value: TRESTRequestMethod);
    procedure SetQueryParams(const Value: TDictionary<TQueryParamKey, TQueryParamValue>);
    procedure SetContentType(const Value: TRESTContentType);
  public
    type Builder = TRESTRequestBuilder;
    property QueryParams: TDictionary<TQueryParamKey, TQueryParamValue> read GetQueryParams write SetQueryParams;
    property QueryParamsKeys[I: Integer]: TQueryParamKey read GetQueryParamsKeys;
    property QueryParamsValues[I: Integer]: TQueryParamValue read GetQueryParamsValues;
    property BaseURL: string read GetBaseURL write SetBaseURL;
    property Host: string read GetHost;
    property EndPoint: string read GetEndPoint write SetEndPoint;
    property URL: string read GetURL;
    property URLWithParams: string read GetURLWithParams;
    property Body: string read GetBody write SetBody;
    property Method: TRESTRequestMethod read GetMethod write SetMethod;
    property ContentType: TRESTContentType read GetContentType write SetContentType;
    procedure AfterConstruction; override;
    destructor Destroy; override;
  end;

implementation

uses
  Math, IdURI, System.RegularExpressions;

{ TRequest }

procedure TRequest.AfterConstruction;
begin
  inherited;
  Self.FMethod := rmGET;
  Self.FQueryParams := TDictionary<TQueryParamKey, TQueryParamValue>.Create;
end;

constructor TRequest.Create;
begin
  { Construtor privado }
end;

destructor TRequest.Destroy;
begin
  Self.FQueryParams.Free;
  inherited;
end;

function TRequest.GetBaseURL: string;
begin
  Result := Self.FBaseURL;
end;

function TRequest.GetBody: string;
begin
  Result := Self.FBody;
end;

function TRequest.GetContentType: TRESTContentType;
begin
  Result := Self.FContentType;
end;

function TRequest.GetEndPoint: string;
begin
  Result := Self.FEndPoint;
end;

function TRequest.GetHost: string;
begin
  Result := TRegEx.Replace(Self.FBaseURL, 'https?\:\/\/', '');
end;

function TRequest.GetMethod: TRESTRequestMethod;
begin
  Result := Self.FMethod;
end;

function TRequest.GetQueryParams: TDictionary<TQueryParamKey, TQueryParamValue>;
begin
  Result := Self.FQueryParams;
end;

function TRequest.GetQueryParamsKeys(I: Integer): TQueryParamKey;
begin
  Result := Self.QueryParams.Keys.ToArray[I];
end;

function TRequest.GetQueryParamsValues(I: Integer): TQueryParamValue;
begin
  Result := Self.QueryParams.Values.ToArray[I];
end;

function TRequest.GetURL: string;
begin
  Result := Format('%s%s', [Self.BaseURL, Self.EndPoint]);
end;

function TRequest.GetURLWithParams: string;
var
  LParamsAsString: string;
  I, LQueryParamsCount: ShortInt;
begin
  LQueryParamsCount := Self.QueryParams.Count;
  LParamsAsString := EmptyStr;
  for I := ZeroValue to Pred(LQueryParamsCount) do
  begin
    if I > ZeroValue then
      LParamsAsString := LParamsAsString + '&';
    LParamsAsString := LParamsAsString + Format('%s=%s', [Self.QueryParamsKeys[I],
                                                          Self.QueryParamsValues[I]]);
  end;
  Result := TIdURI.URLEncode(Format('%s?%s', [Self.URL, LParamsAsString]));
end;

procedure TRequest.SetBaseURL(const Value: string);
begin
  FBaseURL := Value;
end;

procedure TRequest.SetBody(const Value: string);
begin
  FBody := Value;
end;

procedure TRequest.SetContentType(const Value: TRESTContentType);
begin
  FContentType := Value;
end;

procedure TRequest.SetEndPoint(const Value: string);
begin
  FEndPoint := Value;
end;

procedure TRequest.SetMethod(const Value: TRESTRequestMethod);
begin
  FMethod := Value;
end;

procedure TRequest.SetQueryParams(const Value: TDictionary<TQueryParamKey, TQueryParamValue>);
begin
  FQueryParams := Value;
end;

end.
