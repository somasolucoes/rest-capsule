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
  protected
    procedure AddHeaders;
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

uses
  Math;

{ TRESTClientIndyHTTPCommand }

constructor TRESTClientIndyHTTPCommand.Create(ARequest: IRESTRequest;
  AComponent: TIdHTTP);
begin
  Self.FRequest := ARequest;
  Self.FComponent := AComponent;
end;

procedure TRESTClientIndyHTTPCommand.AddHeaders;
var
  I, LHeadersCount: Integer;
begin
  LHeadersCount := Self.FRequest.Headers.Count;
  for I := ZeroValue to Pred(LHeadersCount) do
  begin
    Self.FComponent.Request.CustomHeaders.Values[Self.FRequest.HeadersKeys[I]] :=
      Self.FRequest.HeadersValues[I];
  end;
end;

{ TRESTClientIndyHTTPCommandGet }

function TRESTClientIndyHTTPCommandGet.Execute: string;
var
  LResponse: TStringStream;
begin
  LResponse := nil;
  try
    LResponse := TStringStream.Create(EmptyStr);
    AddHeaders;
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
    AddHeaders;
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
    AddHeaders;
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
    AddHeaders;
    Self.FComponent.Delete(Self.FRequest.URLWithParams, LResponse);
    Result := LResponse.DataString;
  except
    on E: Exception do;
  end;
  LResponse.Free;
end;

end.
