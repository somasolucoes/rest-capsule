unit SomaCapsulas.REST.Source.Adapter.Indy.Factory.Command;

interface

uses
  System.Classes, System.SysUtils, SomaCapsulas.REST.Interfaces,
  IdComponent, IdHTTP, IdBaseComponent;

type
  TRESTClientIndyHTTPCommandFactory = class
    class function Assemble(ARequest: IRESTRequest; AComponent: TIdHTTP): IRESTClientIndyHTTPCommand; static;
  end;

implementation

uses
  SomaCapsulas.REST.Source.Adapter.Indy.Command, REST.Types;

{ TRESTClientIndyHTTPCommandFactory }

class function TRESTClientIndyHTTPCommandFactory.Assemble(
  ARequest: IRESTRequest; AComponent: TIdHTTP): IRESTClientIndyHTTPCommand;
begin
  case ARequest.Method of
    rmGET:
      Result := TRESTClientIndyHTTPCommandGet.Create(ARequest, AComponent);
    rmPOST:
      Result := TRESTClientIndyHTTPCommandPost.Create(ARequest, AComponent);
    rmPUT:
      Result := TRESTClientIndyHTTPCommandPut.Create(ARequest, AComponent);
    rmDELETE:
      Result := TRESTClientIndyHTTPCommandDelete.Create(ARequest, AComponent);
    rmPATCH:;
  end;
end;

end.
