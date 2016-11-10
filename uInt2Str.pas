unit uInt2Str;

interface

uses
  Windows, StrUtils, SysUtils;

function Int2Str(ANumber: Integer; APadezh: Integer; ARod: Integer): string;

implementation

function Int2Str(ANumber: Integer; APadezh: Integer; ARod: Integer): string;
const
  _Ends1: array[1..19] of string = ('первый', 'второй', 'третий', 'четвертый',
    'пятый', 'шестой', 'седьмой', 'восьмой', 'девятый', 'десятый',
    'одиннадцатый', 'двенадцатый', 'тринадцатый', 'четырнадцатый',
    'пятнадцатый', 'шестнадцатый', 'семнадцатый', 'восемнадцатый', 'девятнадцатый');

  _Ends2: array[2..9] of string = ('двадцатый', 'тридцатый', 'сороковой',
    'пятидесятый', 'шестидесятый', 'семидесятый', 'восьмидесятый', 'девяностый');

  _Ends3: array[1..9] of string = ('сотый', 'двухсотый', 'трехсотый', 'четырехсотый',
    'пятисотый', 'шестисотый', 'семисотый', 'восьмисотый', 'девятисотый');
    
  Begins2: array[2..9] of string = ('двадцать', 'тридцать', 'сорок',
    'пятьдесят', 'шестьдесят', 'семьдесят', 'восемьдесят', 'девяносто');

  Begins3: array[1..9] of string = ('сто', 'двести', 'триста', 'четыреста',
    'пятьсот', 'шестьсот', 'семьсот', 'восемьсот', 'девятьсот');

  // Изменение окончаний в падежах относительно Именительного мж.род
  RodPadezh: array[1..4, 1..6] of string = (
    //мж. род
    ('',
     'ый-ого|ой-ого|ий-ьего|',
     'ый-ому|ой-ому|ий-ьему|',
     '',
     'ый-ым|ой-ым|ий-ьим|',
     'ый-ом|ой-ом|ий-ьем|'),

    //жен. род
    ('ый-ая|ой-ая|ий-ья|',
     'ый-ой|ой-ой|ий-ьей|',
     'ый-ой|ой-ой|ий-ьей|',
     'ый-ую|ой-ую|ий-ью|',
     'ый-ой|ой-ой|ий-ьей|',
     'ый-ой|ой-ой|ий-ьей|'),
     
    // ср. род
    ('ый-ое|ой-ое|ий-ье|',
     'ый-ого|ой-ого|ий-ьего|',
     'ый-ому|ой-ому|ий-ьему|',
     'ый-ое|ой-ое|ий-ье|',
     'ый-ым|ой-ым|ий-ьим|',
     'ый-ом|ой-ом|ий-ьем|'),
    
    // мн.число
    ('ый-ые|ой-ые|ий-ьи|',
     'ый-ых|ой-ых|ий-ьих|',
     'ый-ым|ой-ым|ий-ьим|',
     'ый-ые|ой-ые|ий-ьи|',
     'ый-ыми|ой-ыми|ий-ьими|',
     'ый-ых|ой-ых|ий-ьих|')
  );

var
  Ends1: array[1..19] of string;
  Ends2: array[2..9] of string;
  Ends3: array[1..9] of string;
  sNum, s, e1, e2: string;
  i: Integer;
begin
  for i := Low(Ends1) to High(Ends1) do Ends1[i] := _Ends1[i];
  for i := Low(Ends2) to High(Ends2) do Ends2[i] := _Ends2[i];
  for i := Low(Ends3) to High(Ends3) do Ends3[i] := _Ends3[i];

  //Меняем окончания
  s := RodPadezh[ARod, APadezh];
  while s <> '' do begin
    e1 := Copy(s, 1, Pos('-', s) - 1);
    Delete(s, 1, Pos('-', s));
    e2 := Copy(s, 1, Pos('|', s) - 1);
    Delete(s, 1, Pos('|', s));

    for i := Low(Ends1) to High(Ends1) do
      if Pos(ReverseString(e1), ReverseString(Ends1[i])) = 1 then begin
        Delete(Ends1[i], Length(Ends1[i]) - Length(e1) + 1, Length(e1));
        Ends1[i] := Ends1[i] + e2;
      end;

    for i := Low(Ends2) to High(Ends2) do
      if Pos(ReverseString(e1), ReverseString(Ends2[i])) = 1 then begin
        Delete(Ends2[i], Length(Ends2[i]) - Length(e1) + 1, Length(e1));
        Ends2[i] := Ends2[i] + e2;
      end;

    for i := Low(Ends3) to High(Ends3) do
      if Pos(ReverseString(e1), ReverseString(Ends3[i])) = 1 then begin
        Delete(Ends3[i], Length(Ends3[i]) - Length(e1) + 1, Length(e1));
        Ends3[i] := Ends3[i] + e2;
      end;
  end;

  sNum := IntToStr(ANumber);
  Result := sNum;

  s := '';

  repeat
    for i := Low(Ends1) to High(Ends1) do
      if StrToInt(sNum) = i then begin
        Result := Trim(s + ' ' + Ends1[i]);
        Exit;
      end;

    for i := Low(Ends2) to High(Ends2) do
      if StrToInt(sNum) = i * 10 then begin
        Result := Trim(s + ' ' + Ends2[i]);
        Exit;
      end;

    for i := Low(Ends3) to High(Ends3) do
      if StrToInt(sNum) = i * 100 then begin
        Result := Trim(s + ' ' + Ends3[i]);
        Exit;
      end;

    // Двухзначное
    if Length(sNum) = 2 then begin
      for i := Low(Begins2) to High(Begins2) do
        if StrToInt(sNum[1]) = i then begin
          s := Trim(s + ' ' + Begins2[i]);
          Break;
        end;
    end;
    // Трехзначное
    if Length(sNum) = 3 then begin
      for i := Low(Begins3) to High(Begins3) do
        if StrToInt(sNum[1]) = i then begin
          s := Trim(s + ' ' + Begins3[i]);
          Break;
        end;
    end;

    Delete(sNum, 1, 1);
  until sNum = '';
end;


end.
