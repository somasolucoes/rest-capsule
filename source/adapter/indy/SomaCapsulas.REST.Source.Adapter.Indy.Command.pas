unit SomaCapsulas.REST.Source.Adapter.Indy.Command;

interface

uses
  System.Classes, System.SysUtils, SomaCapsulas.REST.Interfaces, IdHTTP, IdComponent;

type
  TRESTClientIndyHTTPCommand = class abstract(TInterfacedObject, IRESTClientIndyHTTPCommand)
  private
    [weak]
    FRequest: IRESTRequest;
    FComponent: TIdHTTP;
  public
    function Execute: string; virtual; abstract;
    constructor Create(ARequest: IRESTRequest; AComponent: TIdHTTP);
  end;

  TRESTClientIndyHTTPCommandGet = class (TRESTClientIndyHTTPCommand)
  public
    function Execute: string; override;
  end;

  TRESTClientIndyHTTPCommandPost = class (TRESTClientIndyHTTPCommand)
  public
    function Execute: string; override;
  end;

  TRESTClientIndyHTTPCommandPut = class (TRESTClientIndyHTTPCommand)
  public
    function Execute: string; override;
  end;

  TRESTClientIndyHTTPCommandDelete = class (TRESTClientIndyHTTPCommand)
  public
    function Execute: string; override;
  end;

implementation

{ TRESTClientIndyHTTPCommand }

constructor TRESTClientIndyHTTPCommand.Create(ARequest: IRESTRequest;
  AComponent: TIdHTTP);
begin
  Self.FRequest := ARequest;
  Self.FComponent := AComponent;
end;

{ TRESTClientIndyHTTPCommandGet }

function TRESTClientIndyHTTPCommandGet.Execute: string;
var
  LResponse: TStringStream;
begin
  LResponse := nil;
  try
    LResponse := TStringStream.Create(EmptyStr);
    Self.FComponent.Get(Self.FRequest.URLWithParams, LResponse);
    Result := LResponse.DataString;
  except
    on E: Exception do;
  end;
  LResponse.Free;
end;

{ TRESTClientIndyHTTPCommandPost }

function TRESTClientIndyHTTPCommandPost.Execute: string;
var
  LRequestBody, LResponse: TStringStream;
  LTexto: string;
begin
  LRequestBody := nil;
  LResponse := nil;
  try
    LResponse := TStringStream.Create(EmptyStr);
    LRequestBody := TStringStream.Create(Self.FRequest.Body);
    Self.FComponent.Post(Self.FRequest.URLWithParams, LRequestBody, LResponse);
    Result := LResponse.DataString;
  except
    on E: Exception do
    begin
      LTexto := E.Message;
    end;
  end;
  LRequestBody.Free;
  LResponse.Free;
end;

{ TRESTClientIndyHTTPCommandPut }

function TRESTClientIndyHTTPCommandPut.Execute: string;
var
  LRequestBody, LResponse: TStringStream;
begin
  LRequestBody := nil;
  LResponse := nil;
  try
    LResponse := TStringStream.Create(EmptyStr);
    LRequestBody := TStringStream.Create(Self.FRequest.Body);
    Self.FComponent.Put(Self.FRequest.URLWithParams, LRequestBody, LResponse);
    Result := LResponse.DataString;
  except
    on E: Exception do;
  end;
  LRequestBody.Free;
  LResponse.Free;
end;

{ TRESTClientIndyHTTPCommandDelete }

function TRESTClientIndyHTTPCommandDelete.Execute: string;
var
  LResponse: TStringStream;
begin
  LResponse := nil;
  try
    LResponse := TStringStream.Create(EmptyStr);
    Self.FComponent.Delete(Self.FRequest.URLWithParams, LResponse);
    Result := LResponse.DataString;
  except
    on E: Exception do;
  end;
  LResponse.Free;
end;

end.
