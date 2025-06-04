#Include "Protheus.ch"
#Include "RwMake.ch"

/*/{Protheus.doc} CT102BUT

Realiza a importação de dados para as tabelas CIS, CIT e CIU da rotina 
Regras por NCM do novo configurador de tributos Protheus.

@type function
@author Joao Pedro Campelo, Rychelle Caminha
@since 04/06/2025

https://github.com/PedroRCampelo/ZIMPCIS

/*/

// Gera ID com base na data/hora + index
Static Function ZGerUUID(nIndex)
    Return DToS(Date()) + StrTran(Time(), ":", "") + StrZero(nIndex, 4)

// Simula hash associativo usando array bidimensional
Static Function SetAssocValue(aArray, cKey, xValue)
    Local n
    For n := 1 To Len(aArray)
        If aArray[n,1] == cKey
            aArray[n,2] := xValue
            Return
        EndIf
    Next
    AAdd(aArray, {cKey, xValue})
Return              

Static Function GetAssocValue(aArray, cKey)
    Local n
    For n := 1 To Len(aArray)
        If aArray[n,1] == cKey
            Return aArray[n,2]
        EndIf
    Next
Return Nil

// Split que preserva campos vazios
Static Function SplitPreservandoVazios(cLinha)
    Local aResult := {}
    Local cCampo := ""
    Local n := 1
    Local cChar := ""

    While n <= Len(cLinha)
        cChar := SubStr(cLinha, n, 1)
        If cChar == ";"
            AAdd(aResult, cCampo)
            cCampo := ""
        Else
            cCampo += cChar
        EndIf
        n++
    EndDo
    AAdd(aResult, cCampo)
Return aResult

User Function ZIMPCIS()
    Local aArea    := GetArea()
    Local cLinha   := ""
    Local aCols    := {}
    Local cTipo    := ""
    Local cID_CIS  := ""
    Local cID_CIT  := ""
    Local cCodNCM  := ""
    Local cTrib    := ""
    Local cUltimoTrib := ""
    Local cChaveTrib := ""
    Local nLin     := 0
    Local cArquivo := "/impncm/impncm.txt"

    Local aLinhas := {}
    Local cConteudo := MemoRead(cArquivo)

    Local aTribCIT := {}
    Local aTribNCM := {}

    If ValType(cConteudo) == "C"
        aLinhas := StrTokArr(cConteudo, Chr(13) + Chr(10))
        If Len(aLinhas) <= 1
            aLinhas := StrTokArr(cConteudo, Chr(10))
        EndIf
    Else
        MsgStop("Falha ao ler o arquivo.")
        Return
    EndIf

    DbSelectArea("CIS")
    DbSelectArea("CIT")
    DbSelectArea("CIU")

    For nLin := 1 To Len(aLinhas)
        cLinha := AllTrim(aLinhas[nLin])
        If Empty(cLinha)
            Loop
        EndIf

        aCols := SplitPreservandoVazios(cLinha)
        While Len(aCols) < 17
            AAdd(aCols, "")
        EndDo

        cTipo := Upper(AllTrim(aCols[1]))

        Do Case
        Case cTipo == "CIS"
            If !Empty(aCols[2])
                cCodNCM := AllTrim(aCols[2])
                cID_CIS := ZGerUUID(nLin)

                CIS->(RecLock("CIS", .T.))
                CIS->CIS_FILIAL := xFilial("CIS")
                CIS->CIS_CODNCM := cCodNCM
                CIS->CIS_ID     := cID_CIS
                CIS->(MsUnlock())
            EndIf

        Case cTipo == "CIT"
            If Len(aCols) >= 2 .And. !Empty(aCols[2])
                cTrib := Upper(AllTrim(aCols[2]))
                cID_CIT := ZGerUUID(nLin)
                cUltimoTrib := cTrib

                CIT->(RecLock("CIT", .T.))
                CIT->CIT_FILIAL := xFilial("CIT")
                CIT->CIT_ID     := cID_CIT
                CIT->CIT_IDNCM  := cID_CIS
                CIT->CIT_TRIB   := cTrib
                CIT->CIT_TIPO   := "1"
                CIT->CIT_NCM    := cCodNCM
                CIT->CIT_ALIQ   := 0
                CIT->(MsUnlock())

                If !Empty(cTrib)
                    SetAssocValue(aTribCIT, cTrib, cID_CIT)
                    SetAssocValue(aTribNCM, cTrib, cCodNCM)
                Else
                    FWLogMsg("Chave de tributo vazia para CIT. Linha: " + cLinha)
                EndIf
            EndIf

        Case cTipo == "CIU"
            cChaveTrib := cUltimoTrib
            cID_CIT := GetAssocValue(aTribCIT, cChaveTrib)
            cCodNCM := GetAssocValue(aTribNCM, cChaveTrib)

            CIU->(RecLock("CIU", .T.))
            CIU->CIU_FILIAL := xFilial("CIU")
            CIU->CIU_ID     := ZGerUUID(nLin)
            CIU->CIU_IDNCM  := cID_CIT
            CIU->CIU_ITEM   := AllTrim(aCols[2])
            CIU->CIU_TIPO   := AllTrim(aCols[3])
            CIU->CIU_UFORI  := AllTrim(aCols[4])
            CIU->CIU_UFDEST := AllTrim(aCols[5])
            CIU->CIU_VIGINI  := StoD(AllTrim(aCols[6]))
            CIU->CIU_VIGFIM := StoD(AllTrim(aCols[7]))
            CIU->CIU_ORIGEM := AllTrim(aCols[8])
            CIU->CIU_CEST   := AllTrim(aCols[9])
            CIU->CIU_MARGEM := Val(StrTran(aCols[10], ",", "."))
            CIU->CIU_MVAAUX := Val(StrTran(aCols[11], ",", "."))
            CIU->CIU_UM     := AllTrim(aCols[12])
            CIU->CIU_VLPAUT := Val(StrTran(aCols[13], ",", "."))
            CIU->CIU_MAJORA := Val(StrTran(aCols[14], ",", "."))
            CIU->CIU_MJAUX := Val(StrTran(aCols[15], ",", "."))
            CIU->CIU_ALIQTR := Val(StrTran(aCols[16], ",", "."))
            CIU->CIU_NCM    := cCodNCM
            CIU->CIU_TRIB   := cChaveTrib
            CIU->(MsUnlock())
        EndCase
    Next

    RestArea(aArea)
    MsgInfo("Importação concluída com sucesso.")
Return
