unit SomaCapsulas.REST.Source.Client;

interface

uses
  System.Classes, System.SysUtils, SomaCapsulas.REST.Interfaces;

type
  TRESTClientBase = class abstract(TInterfacedObject, IRESTClient)
  public
    function ExecuteRequest(ARequest: IRESTRequest; AFallback: TFunc<Exception, IRESTResponse> = nil): IRESTResponse; virtual; abstract;
  end;

implementation end.
