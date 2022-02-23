unit SomaCapsulas.REST.Source.Adapter.Indy.Core;

interface

uses
  System.Classes, System.SysUtils, SomaCapsulas.REST.Source.Client, SomaCapsulas.REST.Interfaces,
  IdHTTP, IdComponent, IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack, IdSSL,
  IdSSLOpenSSL, REST.Types, Web.HTTPApp;

type
  TRESTClientIndy = class(TRESTClientBase)
  private
    FComponent: TIdHTTP;
  protected
    function RetrieveResponse(AResponseBody: string): IRESTResponse;
  public
    function ExecuteRequest(ARequest: IRESTRequest; AFallback: TFunc<Exception, IRESTResponse> = nil): IRESTResponse; override;
    constructor Create(AContentType: TRESTContentType = ctAPPLICATION_JSON);
    destructor Destroy; override;
  end;

implementation

uses
  SomaCapsulas.REST.TTypes, SomaCapsulas.REST.Source.Response, SomaCapsulas.REST.Constants,
  SomaCapsulas.REST.Source.Adapter.Indy.Factory.Command, REST.HttpClient;

{ TRESTClientIndy }

constructor TRESTClientIndy.Create(AContentType: TRESTContentType);
var
  LIOHandler: TIdSSLIOHandlerSocketOpenSSL;
begin
  Self.FComponent := TIdHTTP.Create;
  LIOHandler := TIdSSLIOHandlerSocketOpenSSL.Create(Self.FComponent);
  LIOHandler.SSLOptions.SSLVersions := [sslvTLSv1, sslvTLSv1_1, sslvTLSv1_2];
  Self.FComponent.IOHandler := LIOHandler;
  Self.FComponent.HandleRedirects := True;
  Self.FComponent.ConnectTimeout := REST_REQUEST_TIMEOUT;
  Self.FComponent.ReadTimeout := REST_REQUEST_TIMEOUT;
  Self.FComponent.Request.ContentType := ContentTypeToString(AContentType);
  Self.FComponent.Request.CharSet := 'UTF-8';
  Self.FComponent.Request.UserAgent := 'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20100101 Firefox/12.0';
  Self.FComponent.Response.ContentType := ContentTypeToString(AContentType);
  Self.FComponent.Response.CharSet := 'UTF-8';
end;

destructor TRESTClientIndy.Destroy;
begin
  Self.FComponent.Free;
  inherited;
end;

function TRESTClientIndy.ExecuteRequest(
  ARequest: IRESTRequest; AFallback: TFunc<Exception, IRESTResponse>): IRESTResponse;
var
  LCommand: IRESTClientIndyHTTPCommand;
  LResponseBody: string;
  LResponse, LFallbackResponse: IRESTResponse;
begin
  Result := nil;
  try
    LCommand := TRESTClientIndyHTTPCommandFactory.Assemble(ARequest, Self.FComponent);
    LResponseBody := LCommand.Execute;
    LResponse := RetrieveResponse(LResponseBody);
    Result := LResponse;
  except
    on E: Exception do
    begin
      if not Assigned(AFallback) then
        raise;
      LFallbackResponse := AFallback(E);
      Result := LFallbackResponse;
    end;
  end;
end;

function TRESTClientIndy.RetrieveResponse(AResponseBody: string): IRESTResponse;
var
  LContentType: TRESTContentType;
  LStatus: IRESTResponseStatus;
  LStatusCode: Word;
begin
  LContentType := ContentTypeFromString(Self.FComponent.Response.ContentType);
  LStatusCode := Self.FComponent.Response.ResponseCode;
  LStatus := TResponseStatus.Create(LStatusCode, StatusString(LStatusCode));
  Result := TResponse.Create(AResponseBody, LContentType, LStatus);
end;

end.
