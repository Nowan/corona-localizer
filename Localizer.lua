--[[

	Module to make localization implementation much faster and easier.

	Usage:

	1. Fill localizer.Culture table with culture codes of languages you want
	   your application to support, in format:
	   { [language] = [culture_code], [language] = [culture_code], ... }

	   For example:
	   localizer.Culture = {
	   	   English = "en_US",
	   	   Ukrainian = "uk_UA",
	   	   Polish = "pl_PL"
	   }

	   Culture codes can be found on https://msdn.microsoft.com/en-us/library/ee825488

	2. Create a folder which will store resource files for translations
	   Inside, create a new file named [culture_code].xml for each culture code provided in localizer.Culture.
	   Set localizer.sourceDir a name of the resources folder

	   For example:
	   Create directory ./localization/
	   Create file ./localization/en_US.xml
	   Create file ./localization/uk_UA.xml
	   Create file ./localization/pl_PL.xml

	   localizer.sourceDir = "localization";

	3. Files [culture_code].xml are storing text translations in appropriate language in format
		<culture code="[culture_code]">
			<[translation_id]>[translated_text]</[translation_id]> <!--[some_description(optional)]-->
			<[translation_id]>[translated_text]</[translation_id]> <!--[some_description(optional)]-->
			<[translation_id]>[translated_text]</[translation_id]> <!--[some_description(optional)]-->
												...
		</culture>

		For example:
		./localization/en_US.xml:
		<culture code="en-US">
			<greetTxt>Hi there! What's up?</greetTxt><!-- Displayed on app startup -->
			<playTxt>Start playing</playTxt><!-- Displayed in main menu -->
			<continueTxt>Let us continue!</continueTxt><!-- Displayed in main menu -->
		</culture>

		./localization/uk_UA.xml:
		<culture code="uk-UA">
			<greetTxt>Привіт! Як твої справи?</greetTxt><!-- Displayed on app startup -->
			<playTxt>Почати гру</playTxt><!-- Displayed in main menu -->
			<continueTxt>Давайте ж продовжимо!</continueTxt><!-- Displayed in main menu -->
		</culture>

		./localization/pl_PL.xml:
		<culture code="pl-PL">
			<greetTxt>Cześć! Co słychać?</greetTxt><!-- Displayed on app startup -->
			<playTxt>Rozpocząć grę</playTxt><!-- Displayed in main menu -->
			<continueTxt>Kontynujemy!</continueTxt><!-- Displayed in main menu -->
		</culture>

	4. In main.lua:
	localizer = require("Localizer"); -- it's better to make localizer global variable(used everywhere)
	localizer:setCulture(localizer.Culture.English);
	local translation = localizer:getTranslation("greetTxt");
	print(translation);

]]--
local localizer = {};

local xml = require("xml").newParser();

--------------------------------------------------------------------------------
--	Properties
--------------------------------------------------------------------------------

-- culture codes from https://msdn.microsoft.com/en-us/library/ee825488(v=cs.20).aspx
localizer.Culture = {
	English = "en_US",
	Ukrainian = "uk_UA",
	Polish = "pl_PL"
}

localizer.defaultCulture = system.getPreference("ui", "language");
localizer.currentCulture = localizer.defaultCulture;
localizer.translations = nil;

-- path to directory with translations
localizer.sourceDir = "localization";

--------------------------------------------------------------------------------
--	Methods declarations
--------------------------------------------------------------------------------
local setCulture, getTranslation;

function localizer:setCulture(cultureCode)
	setCulture(cultureCode);
end

function localizer:getTranslation(translationID)
	return getTranslation(translationID);
end

--------------------------------------------------------------------------------
--	Methods initializations
--------------------------------------------------------------------------------

-- read localization files
local function parseTranslations()
	-- add slash at the end of localizer.sourceDir if missing
	local char = string.sub(localizer.sourceDir,string.len(localizer.sourceDir));
	localizer.sourceDir = char~='/' and localizer.sourceDir..'/' or localizer.sourceDir;

	-- fill localizer.translations table with data
	localizer.translations = {};
	for key,value in pairs(localizer.Culture) do
		local translation = {}; -- table of translations for current culture

		local filePath = string.gsub(value, "-", "_")..".xml";
		filePath = localizer.sourceDir..filePath;

		if system.pathForFile( filePath, system.ResourceDirectory ) then
			local parsedXml = xml:loadFile( filePath );

			translation.code = parsedXml.properties.code;
			for i=1,#parsedXml.child do
				local child = parsedXml.child[i];
				translation[child.name] = child.value;
			end

			localizer.translations[key] = translation;
		end
	end
end
parseTranslations();

local function getCultureKey(cultureCode)
	for key,value in pairs(localizer.Culture) do
		if(cultureCode==value) then
			return key;
		end
	end
end

setCulture = function(cultureCode)
	localizer.currentCulture = getCultureKey(cultureCode);
end

getTranslation = function(translationID)
	local translation;
	if localizer.translations[localizer.currentCulture] then
		-- return translation under current id in chosen culture if possible
		translation = localizer.translations[localizer.currentCulture][translationID];
		translation = translation and translation or "";
	else
		-- else return translation under current id in default culture if possible
		local defaultCultureKey = getCultureKey(localizer.defaultCulture);
		print(localizer.defaultCulture)
		if localizer.translations[defaultCultureKey] then
			translation = localizer.translations[defaultCultureKey][translationID];
			translation = translation and translation or "";
		else
			-- return empty string if culture or translation don't exist
			translation = "";
		end
	end
	return translation;
end

return localizer;
