/// <summary>
/// obsahuje funkce uzitecne pro praci s Job Queue
/// </summary>
codeunit 150021 "Job Queue Utils_jq"
{
    Access = Internal;

    var
        JobQAppSetup: Record "Job Q App Setup_jq";

    /// <summary>
    /// rozdeli retezec parametru z pole "Parameter String" pomoci definovaneho oddelovace
    ///
    /// </summary>
    /// <param name="ParameterString">retezec parametru</param>
    /// <returns>list parametru pro iteraci</returns>
    [Scope('OnPrem')]
    procedure ParseParameterString
    (
        ParameterString: Text[250]
    ) Parameters: List of [Text];
    var
    begin
        JobQAppSetup.GetRecordOnce();
        Parameters := ParameterString.Split(JobQAppSetup."Param. String Separator");
        if CheckHash(Parameters) then;
    end;

    /// <summary>
    /// zkontroluje, ze posledni parametr odpovida hashi z predchozich parametru
    /// </summary>
    /// <param name="Params">parametry</param>
    /// <param name="Separator">oddelovac</param>
    /// <returns>**TRUE**, pokud se zadany hash rovna vypocitanemu, jinak **FALSE**</returns>
    [Scope('OnPrem')]
    procedure CheckHash(Params: List of [Text]): Boolean;
    var
        CryptographyManagement: Codeunit "Cryptography Management";
        TxtToHash, Hash : Text;
        i: Integer;
        HashAlgorithmType: Option MD5,SHA1,SHA256,SHA384,SHA512;
    begin
        JobQAppSetup.GetRecordOnce();

        if not JobQAppSetup."Use Checksum" then
            exit(true);

        if Params.Count() < 2 then
            exit(false);

        for i := 1 to Params.Count() - 1 do
            TxtToHash += Params.Get(i) + JobQAppSetup."Param. String Separator";

        TxtToHash := TxtToHash.TrimEnd(JobQAppSetup."Param. String Separator");

        HashAlgorithmType := HashAlgorithmType::SHA256;
        Hash := CryptographyManagement.GenerateHash(TxtToHash, HashAlgorithmType);

        exit(Hash = Params.Get(Params.Count()));
    end;

    [Scope('OnPrem')]
    procedure CheckHash(Params: Text[250]): Boolean;
    begin
        JobQAppSetup.GetRecordOnce();

        if not JobQAppSetup."Use Checksum" then
            exit(true);

        exit(CheckHash(Params.Split(JobQAppSetup."Param. String Separator")));
    end;

}
