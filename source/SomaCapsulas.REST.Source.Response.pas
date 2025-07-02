unit SomaCapsulas.REST.Source.Response;

interface

uses
  System.Classes, System.SysUtils, SomaCapsulas.REST.Interfaces, SomaCapsulas.REST.TTypes,
  REST.Types;

type
  TResponse = class(TInterfacedObject, IRESTResponse)
  private
    FBody: string;
    FContentType: TRESTContentType;
    FStatus: IRESTResponseStatus;
    function GetBody: string;
    function GetContentType: TRESTContentType;
    function GetStatus: IRESTResponseStatus;
    procedure SetBody(const Value: string);
    procedure SetContentType(const Value: TRESTContentType);
    procedure SetStatus(const Value: IRESTResponseStatus);
  public
    property Status: IRESTResponseStatus read GetStatus write SetStatus;
    property Body: string read GetBody write SetBody;
    property ContentType: TRESTContentType read GetContentType write SetContentType;
    constructor Create(ABody: string; AContentType: TRESTContentType; AStatus: IRESTResponseStatus);
  end;

  TResponseStatus = class(TInterfacedObject, IRESTResponseStatus)
  private
    FCode: Word;
    FText: string;
    function GetCode: Word;
    function GetText: string;
    procedure SetCode(const Value: Word);
    procedure SetText(const Value: string);
  public
    property Code: Word read GetCode write SetCode;
    property Text: string read GetText write SetText;
    constructor Create(ACode: Word; AText: string);
  end;

implementation

{ TResponse }

constructor TResponse.Create(ABody: string; AContentType: TRESTContentType;
  AStatus: IRESTResponseStatus);
begin
  Self.FBody := ABody;
  Self.FContentType := AContentType;
  Self.FStatus := AStatus;
end;

function TResponse.GetBody: string;
begin
  Result := Self.FBody;
end;

function TResponse.GetContentType: TRESTContentType;
begin
  Result := Self.FContentType;
end;

function TResponse.GetStatus: IRESTResponseStatus;
begin
  Result := Self.FStatus;
end;

procedure TResponse.SetBody(const Value: string);
begin
  FBody := Value;
end;

procedure TResponse.SetContentType(const Value: TRESTContentType);
begin
  FContentType := Value;
end;

procedure TResponse.SetStatus(const Value: IRESTResponseStatus);
begin
  FStatus := Value;
end;

{ TResponseStatus }

constructor TResponseStatus.Create(ACode: Word; AText: string);
begin
  Self.FCode := ACode;
  Self.FText := AnsiUpperCase(AText);
end;

function TResponseStatus.GetCode: Word;
begin
  Result := Self.FCode;
end;

function TResponseStatus.GetText: string;
begin
  Result := Self.FText;
end;

procedure TResponseStatus.SetCode(const Value: Word);
begin
  FCode := Value;
end;

procedure TResponseStatus.SetText(const Value: string);
begin
  FText := Value;
end;

end.

