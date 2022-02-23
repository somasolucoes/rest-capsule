unit SomaCapsulas.REST.Source.Factory.Client;

interface

uses
  System.Classes, System.SysUtils, SomaCapsulas.REST.Interfaces, SomaCapsulas.REST.TTypes;

type
  TRESTClientFactory = class
    class function Assemble(AClientAdapterKind: TRESTClientAdapterKind): IRESTClient; static;
  end;

implementation

uses
  SomaCapsulas.REST.Source.Adapter.Native.Core, SomaCapsulas.REST.Source.Adapter.Indy.Core,
  SomaCapsulas.REST.Exception, SomaCapsulas.REST.Message;

{ TRESTClientFactory }

class function TRESTClientFactory.Assemble(AClientAdapterKind: TRESTClientAdapterKind): IRESTClient;
begin
  case AClientAdapterKind of
    rcaNative: Result := TRESTClientNative.Create;
    rcaIndy: Result := TRESTClientIndy.Create;
    else
      raise ESomaCapsulasREST.Create(E_SCR_0001);
  end;
end;

end.
