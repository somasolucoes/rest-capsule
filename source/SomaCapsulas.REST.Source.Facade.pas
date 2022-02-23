unit SomaCapsulas.REST.Source.Facade;

interface

uses
  System.Classes, System.SysUtils, SomaCapsulas.REST.Interfaces, SomaCapsulas.REST.TTypes,
  SomaCapsulas.Interfaces, System.Generics.Collections, REST.Types, SomaCapsulas.Log.Types,
  SomaCapsulas.Log.Interfaces;

type
  TRESTFacade = class(TInterfacedObject, IRESTFacade)
  private
    FClient: IRESTClient;
    FRequest: IRESTRequest;
    FResponse: IRESTResponse;
    FBaseUrl: string;
    FQueryParams: TDictionary<TQueryParamKey, TQueryParamValue>;
    FOnRequestSuccess: TProc<IRESTResponse>;
    FOnRequestError: TProc<IRESTResponse>;
    FHasResponse: Boolean;
    function GetOnRequestError: TProc<IRESTResponse>;
    function GetOnRequestSuccess: TProc<IRESTResponse>;
    function GetHasResponse: Boolean;
    function GetWasRequestSuccessful: Boolean;
    procedure SetOnRequestError(const Value: TProc<IRESTResponse>);
    procedure SetOnRequestSuccess(const Value: TProc<IRESTResponse>);
  protected
    procedure CallResponseHandler;
  public
    property OnRequestSuccess: TProc<IRESTResponse> read GetOnRequestSuccess write SetOnRequestSuccess;
    property OnRequestError: TProc<IRESTResponse> read GetOnRequestError write SetOnRequestError;
    property HasResponse: Boolean read GetHasResponse;
    property WasRequestSuccessful: Boolean read GetWasRequestSuccessful;
    procedure PrepareRequest(AEndPoint, ABody: string; AContentType: TRESTContentType; AMethod: TRESTRequestMethod);
    procedure AddQueryParamRequest(AKey, AValue: string);
    function ExecuteRequest: IRESTResponse;
    procedure GenerateLogResponse(ALogStrategy: ILogStrategy);
    procedure CleanQueryParams;
    procedure CleanRequest;
    constructor Create(AClient: IRESTClient; ABaseUrl: string);
    destructor Destroy; override;
  end;

implementation

uses
  SomaCapsulas.REST.Source.Builder.Request, SomaCapsulas.REST.Exception,
  SomaCapsulas.REST.Message;

{ TRESTFacade }

constructor TRESTFacade.Create(AClient: IRESTClient; ABaseUrl: string);
begin
  Self.FClient := AClient;
  Self.FBaseUrl := ABaseUrl;
  Self.FQueryParams := TDictionary<TQueryParamKey, TQueryParamValue>.Create;
  CleanQueryParams;
end;

destructor TRESTFacade.Destroy;
begin
  Self.FQueryParams.Free;
  inherited;
end;

procedure TRESTFacade.PrepareRequest(AEndPoint, ABody: string;
  AContentType: TRESTContentType; AMethod: TRESTRequestMethod);
var
  LRequestBuilder: IRESTRequestBuilder;
begin
  LRequestBuilder := TRESTRequestBuilder.Create;
  Self.FRequest :=
    LRequestBuilder.OnBaseURL(Self.FBaseUrl)
                   .AtEndPoint(AEndPoint)
                   .WithContentType(AContentType)
                   .WithBody(ABody)
                   .UsingMethod(AMethod)
                   .UsingQueryParams(Self.FQueryParams)
                   .Build;
end;

procedure TRESTFacade.AddQueryParamRequest(AKey, AValue: string);
begin
  Self.FQueryParams.AddOrSetValue(AKey, AValue);
end;

function TRESTFacade.ExecuteRequest: IRESTResponse;
begin
  if not Assigned(Self.FRequest) then
    raise ESomaCapsulasRESTRequest.Create(E_SCR_0002);
  Self.FResponse := Self.FClient.ExecuteRequest(Self.FRequest);
  Result := Self.FResponse;
  CallResponseHandler;
end;

procedure TRESTFacade.CallResponseHandler;
begin
  if Self.WasRequestSuccessful then
  begin
    if Assigned(Self.OnRequestSuccess) then
      Self.OnRequestSuccess(Self.FResponse);
  end
  else
  begin
    if Assigned(Self.OnRequestError) then
      Self.OnRequestError(Self.FResponse);
  end;
end;

procedure TRESTFacade.CleanQueryParams;
begin
  Self.FQueryParams.Clear;
  Self.FQueryParams.TrimExcess;
end;

procedure TRESTFacade.CleanRequest;
begin
  CleanQueryParams;
  Self.FRequest := nil;
  Self.FResponse := nil;
end;

procedure TRESTFacade.SetOnRequestError(const Value: TProc<IRESTResponse>);
begin
  FOnRequestError := Value;
end;

procedure TRESTFacade.SetOnRequestSuccess(const Value: TProc<IRESTResponse>);
begin
  FOnRequestSuccess := Value;
end;

procedure TRESTFacade.GenerateLogResponse(ALogStrategy: ILogStrategy);
begin
  if (Self.HasResponse) then
  begin
    ALogStrategy.Generate(Format('%s [%d - %s] %s', [RESTRequestMethodToString(Self.FRequest.Method),
                                             Self.FResponse.Status.Code,
                                             Self.FResponse.Status.Text,
                                             Self.FRequest.EndPoint]));
  end;
end;

function TRESTFacade.GetHasResponse: Boolean;
begin
  Result := Assigned(Self.FResponse);
end;

function TRESTFacade.GetOnRequestError: TProc<IRESTResponse>;
begin
  Result := Self.FOnRequestError;
end;

function TRESTFacade.GetOnRequestSuccess: TProc<IRESTResponse>;
begin
  Result := Self.FOnRequestSuccess;
end;

function TRESTFacade.GetWasRequestSuccessful: Boolean;
begin
  Result := (Self.HasResponse) and (Self.FResponse.Status.Code >= 200) and (Self.FResponse.Status.Code < 300);
end;

end.
