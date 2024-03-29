; Copyright (c) TechieCable 2020-2021
analytics(Exception) {
	global analyticsKey
	global version
	analyticsURL := "https://docs.google.com/forms/d/e/" . analyticsKey . "/formResponse?usp=pp_url&entry.582498019=" . utf8er(A_NowUTC) . "&entry.1604696247=" . utf8er(A_ScriptDir) . "&entry.306217276=" . utf8er(A_WorkingDir) . "&entry.667006729=" . utf8er(A_ScriptName) . "&entry.1069664008=" . utf8er(A_ComputerName) . "&entry.1130611317=" . utf8er(A_IsAdmin) . "&entry.451930632=" . utf8er(ErrorLevel) . "&entry.1116588869=" . utf8er(Exception) . "&entry.80569175=" . utf8er(A_AhkVersion) . "&entry.108374315=" . utf8er(version) . "&entry.1973132616=" . utf8er(A_OSVersion) . "&entry.2095529728=" . utf8er(A_Is64bitOS) . "&entry.267866814="
	for n, param in A_Args
	{
		analyticsArgs .= "(" n ") > " param "`n"
	}
	analyticsURL .= utf8er(analyticsArgs) "&submit=Submit"
	return analyticsURL
}

utf8er(input) {
	input := StrReplace(input, "`%", "%25")
	input := StrReplace(input, A_UserName, "<u='" A_UserName "'>")
	input := StrReplace(input, "`n", "%0A")
	input := StrReplace(input, "`n`r", "%0A")
	input := StrReplace(input, " ", "%20")
	input := StrReplace(input, """", "%22")
	input := StrReplace(input, "#", "%23")
	input := StrReplace(input, "&", "%26")
	input := StrReplace(input, "+", "%2B")
	input := StrReplace(input, "<", "%3C")
	input := StrReplace(input, "=", "%3D")
	input := StrReplace(input, ">", "%3E")
	input := StrReplace(input, "[", "%5B")
	input := StrReplace(input, "\", "%5C")
	input := StrReplace(input, "]", "%5D")
	input := StrReplace(input, "^", "%5E")
	input := StrReplace(input, "``", "%60")
	input := StrReplace(input, "{", "%7B")
	input := StrReplace(input, "|", "%7C")
	input := StrReplace(input, "}", "%7D")
	input := StrReplace(input, "‚", "%E2%80%9A")
	input := StrReplace(input, "ƒ", "%C6%92")
	input := StrReplace(input, "„", "%E2%80%9E")
	input := StrReplace(input, "…", "%E2%80%A6")
	input := StrReplace(input, "†", "%E2%80%A0")
	input := StrReplace(input, "‡", "%E2%80%A1")
	input := StrReplace(input, "ˆ", "%CB%86")
	input := StrReplace(input, "‰", "%E2%80%B0")
	input := StrReplace(input, "Š", "%C5%A0")
	input := StrReplace(input, "‹", "%E2%80%B9")
	input := StrReplace(input, "Œ", "%C5%92")
	input := StrReplace(input, "ō", "%C5%8D")
	input := StrReplace(input, "Ž", "%C5%BD")
	input := StrReplace(input, "‘", "%E2%80%98")
	input := StrReplace(input, "’", "%E2%80%99")
	input := StrReplace(input, "“", "%E2%80%9C")
	input := StrReplace(input, "”", "%E2%80%9D")
	input := StrReplace(input, "•", "%E2%80%A2")
	input := StrReplace(input, "–", "%E2%80%93")
	input := StrReplace(input, "—", "%E2%80%94")
	input := StrReplace(input, "˜", "%CB%9C")
	input := StrReplace(input, "™", "%E2%84%A2")
	input := StrReplace(input, "š", "%C5%A1")
	input := StrReplace(input, "›", "%E2%80%BA")
	input := StrReplace(input, "œ", "%C5%93")
	input := StrReplace(input, "ž", "%C5%BE")
	input := StrReplace(input, "Ÿ", "%C5%B8")
	input := StrReplace(input, "¡", "%C2%A1")
	input := StrReplace(input, "¢", "%C2%A2")
	input := StrReplace(input, "£", "%C2%A3")
	input := StrReplace(input, "¤", "%C2%A4")
	input := StrReplace(input, "¥", "%C2%A5")
	input := StrReplace(input, "¦", "%C2%A6")
	input := StrReplace(input, "§", "%C2%A7")
	input := StrReplace(input, "¨", "%C2%A8")
	input := StrReplace(input, "©", "%C2%A9")
	input := StrReplace(input, "ª", "%C2%AA")
	input := StrReplace(input, "«", "%C2%AB")
	input := StrReplace(input, "¬", "%C2%AC")
	input := StrReplace(input, "­", "%C2%AD")
	input := StrReplace(input, "®", "%C2%AE")
	input := StrReplace(input, "¯", "%C2%AF")
	input := StrReplace(input, "°", "%C2%B0")
	input := StrReplace(input, "±", "%C2%B1")
	input := StrReplace(input, "²", "%C2%B2")
	input := StrReplace(input, "³", "%C2%B3")
	input := StrReplace(input, "´", "%C2%B4")
	input := StrReplace(input, "µ", "%C2%B5")
	input := StrReplace(input, "¶", "%C2%B6")
	input := StrReplace(input, "·", "%C2%B7")
	input := StrReplace(input, "¸", "%C2%B8")
	input := StrReplace(input, "¹", "%C2%B9")
	input := StrReplace(input, "º", "%C2%BA")
	input := StrReplace(input, "»", "%C2%BB")
	input := StrReplace(input, "¼", "%C2%BC")
	input := StrReplace(input, "½", "%C2%BD")
	input := StrReplace(input, "¾", "%C2%BE")
	input := StrReplace(input, "¿", "%C2%BF")
	input := StrReplace(input, "À", "%C3%80")
	input := StrReplace(input, "Á", "%C3%81")
	input := StrReplace(input, "Â", "%C3%82")
	input := StrReplace(input, "Ã", "%C3%83")
	input := StrReplace(input, "Ä", "%C3%84")
	input := StrReplace(input, "Å", "%C3%85")
	input := StrReplace(input, "Æ", "%C3%86")
	input := StrReplace(input, "Ç", "%C3%87")
	input := StrReplace(input, "È", "%C3%88")
	input := StrReplace(input, "É", "%C3%89")
	input := StrReplace(input, "Ê", "%C3%8A")
	input := StrReplace(input, "Ë", "%C3%8B")
	input := StrReplace(input, "Ì", "%C3%8C")
	input := StrReplace(input, "Í", "%C3%8D")
	input := StrReplace(input, "Î", "%C3%8E")
	input := StrReplace(input, "Ï", "%C3%8F")
	input := StrReplace(input, "Ð", "%C3%90")
	input := StrReplace(input, "Ñ", "%C3%91")
	input := StrReplace(input, "Ò", "%C3%92")
	input := StrReplace(input, "Ó", "%C3%93")
	input := StrReplace(input, "Ô", "%C3%94")
	input := StrReplace(input, "Õ", "%C3%95")
	input := StrReplace(input, "Ö", "%C3%96")
	input := StrReplace(input, "×", "%C3%97")
	input := StrReplace(input, "Ø", "%C3%98")
	input := StrReplace(input, "Ù", "%C3%99")
	input := StrReplace(input, "Ú", "%C3%9A")
	input := StrReplace(input, "Û", "%C3%9B")
	input := StrReplace(input, "Ü", "%C3%9C")
	input := StrReplace(input, "Ý", "%C3%9D")
	input := StrReplace(input, "Þ", "%C3%9E")
	input := StrReplace(input, "ß", "%C3%9F")
	input := StrReplace(input, "à", "%C3%A0")
	input := StrReplace(input, "á", "%C3%A1")
	input := StrReplace(input, "â", "%C3%A2")
	input := StrReplace(input, "ã", "%C3%A3")
	input := StrReplace(input, "ä", "%C3%A4")
	input := StrReplace(input, "å", "%C3%A5")
	input := StrReplace(input, "æ", "%C3%A6")
	input := StrReplace(input, "ç", "%C3%A7")
	input := StrReplace(input, "è", "%C3%A8")
	input := StrReplace(input, "é", "%C3%A9")
	input := StrReplace(input, "ê", "%C3%AA")
	input := StrReplace(input, "ë", "%C3%AB")
	input := StrReplace(input, "ì", "%C3%AC")
	input := StrReplace(input, "í", "%C3%AD")
	input := StrReplace(input, "î", "%C3%AE")
	input := StrReplace(input, "ï", "%C3%AF")
	input := StrReplace(input, "ð", "%C3%B0")
	input := StrReplace(input, "ñ", "%C3%B1")
	input := StrReplace(input, "ò", "%C3%B2")
	input := StrReplace(input, "ó", "%C3%B3")
	input := StrReplace(input, "ô", "%C3%B4")
	input := StrReplace(input, "õ", "%C3%B5")
	input := StrReplace(input, "ö", "%C3%B6")
	input := StrReplace(input, "÷", "%C3%B7")
	input := StrReplace(input, "ø", "%C3%B8")
	input := StrReplace(input, "ù", "%C3%B9")
	input := StrReplace(input, "ú", "%C3%BA")
	input := StrReplace(input, "û", "%C3%BB")
	input := StrReplace(input, "ü", "%C3%BC")
	input := StrReplace(input, "ý", "%C3%BD")
	input := StrReplace(input, "þ", "%C3%BE")
	input := StrReplace(input, "ÿ", "%C3%BF")
	return input
}
