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
	input := StrReplace(input, "`n", "%0A")
	input := StrReplace(input, "`n`r", "%0A")
	input := StrReplace(input, " ", "%20")
	input := StrReplace(input, "!", "%21")
	input := StrReplace(input, """", "%22")
	input := StrReplace(input, "#", "%23")
	input := StrReplace(input, "$", "%24")
	input := StrReplace(input, "&", "%26")
	input := StrReplace(input, "'", "%27")
	input := StrReplace(input, "(", "%28")
	input := StrReplace(input, "`)", "%29")
	input := StrReplace(input, "*", "%2A")
	input := StrReplace(input, "+", "%2B")
	input := StrReplace(input, ",", "%2C")
	input := StrReplace(input, "-", "%2D")
	input := StrReplace(input, ".", "%2E")
	input := StrReplace(input, "/", "%2F")
	input := StrReplace(input, ":", "%3A")
	input := StrReplace(input, ";", "%3B")
	input := StrReplace(input, "<", "%3C")
	input := StrReplace(input, "=", "%3D")
	input := StrReplace(input, ">", "%3E")
	input := StrReplace(input, "?", "%3F")
	input := StrReplace(input, "@", "%40")
	input := StrReplace(input, "[", "%5B")
	input := StrReplace(input, "\", "%5C")
	input := StrReplace(input, "]", "%5D")
	input := StrReplace(input, "^", "%5E")
	input := StrReplace(input, "_", "%5F")
	input := StrReplace(input, "`", "%60")
	input := StrReplace(input, "{", "%7B")
	input := StrReplace(input, "|", "%7C")
	input := StrReplace(input, "}", "%7D")
	input := StrReplace(input, "~", "%7E")
	input := StrReplace(input, A_UserName, "<username>")
	return input
}
