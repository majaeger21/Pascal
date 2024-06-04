program assign8;

{Data Types }

type
NumC = record
   n : integer; 
end;

type
StrC = record
   s : packed array [1..50] of char;
end;

type
  ExprC = record
    case exp: Integer of
      1: (Num: NumC);
      2: (Str: StrC);
  end;

function GetDataType(U: ExprC): String;
begin
  case U.DataType of
    1: GetDataType := 'NumC';
    2: GetDataType := 'StrC';
  else
    GetDataType := 'Unknown';
  end;
end;

var
   E1: ExprC;

var
   n1: NumC;

begin
   n1.n := 20;
   E1.exp := 1;
   E1.Num := n1;
   writeln('Data type is', GetDataType(E1));
   writeln('Attempt to print NumC', E1.Num);

end.