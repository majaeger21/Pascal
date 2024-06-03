program assign8

{Data Types }

type
NumC = record
   n : integer 
end;

type
StrC = record
   s : packed array [1..50] of char;
end;