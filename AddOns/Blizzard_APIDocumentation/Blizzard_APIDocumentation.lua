APIDocumentationMixin = {};

-- "public"
function APIDocumentationMixin:OnLoad()
	self.tables = {};
	self.functions = {};
	self.systems = {};
	self.fields = {};
end

function APIDocumentationMixin:HandleSlashCommand(command)
	local commands = { (" "):split(command) };

	if commands[1] == "?" or commands[1] == "help" or commands[1] == "" then
		self:OutputUsage();
	elseif commands[1] == "stats" then
		self:OutputStats();
	elseif commands[1] == "system" then
		if commands[2] == "list" then
			self:OutputAllSystems();
		else
			self:OutputUsage();
		end
	elseif commands[1] == "s" or commands[1] == "search" then
		self:OutputAllAPIMatches(unpack(commands, 2));
	elseif commands[1] then
		self:TryHandlingSystemSearchCommand(unpack(commands));
	else
		self:OutputUsage();
	end
end

function APIDocumentationMixin:HandleAPILink(link, copyAPI)
	local _, type, name, parentName = (":"):split(link);
	local apiInfo = self:FindAPIByName(type, name, parentName);
	if apiInfo then
		if copyAPI and CopyToClipboard then -- CopyToClipboard could be implemented as an edit box the user could copy from
			local clipboardString = apiInfo:GetClipboardString();
			CopyToClipboard(clipboardString);
			self:WriteLineF("Copied to clipboard: %s", clipboardString);
		else
			self:WriteLine(" ");
			self:WriteAllLines(apiInfo:GetDetailedOutputLines());
		end
	end
end

function APIDocumentationMixin:FindAPIByName(apiType, name, parentName)
	local apiTable = self:GetAPITableByTypeName(apiType);
	if apiTable then
		for i, apiInfo in ipairs(apiTable) do
			if apiInfo:MatchesName(name, parentName) then
				return apiInfo;
			end
		end
	end
	return nil;
end

function APIDocumentationMixin:GetAPITableByTypeName(apiType)
	if apiType == "function" then
		return self.functions;
	elseif apiType == "table" then
		return self.tables;
	elseif apiType == "system" then
		return self.systems;
	elseif apiType == "field" then
		return self.fields;
	end
	return nil;
end

function APIDocumentationMixin:OutputUsage()
	self:WriteLine("Usage:");

	self:WriteLine("Search for API");
	self:WriteLine(self:GetIndentString() .. "/api search <api name>");
	self:WriteLine(self:GetIndentString() .. "or");
	self:WriteLine(self:GetIndentString() .. "/api s <api name>");
	self:WriteLine(self:GetIndentString() .. "Example: /api search item");
	self:WriteLine(" ");

	self:WriteLine("List all systems");
	self:WriteLine(self:GetIndentString() .. "/api system list");
	self:WriteLine(" ");

	self:WriteLine("Search system for API");
	self:WriteLine(self:GetIndentString() .. "/api <system name> search <api name>");
	self:WriteLine(self:GetIndentString() .. "or");
	self:WriteLine(self:GetIndentString() .. "/api <system name> s <api name>");
	self:WriteLine(self:GetIndentString() .. "Example: /api artifactui search relic");
	self:WriteLine(" ");

	self:WriteLine("List all API in a system");
	self:WriteLine(self:GetIndentString() .. "/api <system name> list");
	self:WriteLine(self:GetIndentString() .. "Example: /api artifactui list");
	self:WriteLine(" ");
	self:WriteLine("All searches support Lua patterns.");
end

function APIDocumentationMixin:OutputStats()
	self:WriteLine("Stats:");
	self:WriteLineF("Total systems: %d", #self.systems);
	local totalFunctions = 0;
	local totalTables = 0;

	for i, systemInfo in ipairs(self.systems) do
		totalFunctions = totalFunctions + systemInfo:GetNumFunctions();
		totalTables = totalTables + systemInfo:GetNumTables();
	end

	self:WriteLineF("Total functions: %d", totalFunctions);
	self:WriteLineF("Total tables: %d", totalTables);
end

function APIDocumentationMixin:OutputAllSystems()
	self:WriteLineF("All systems (%d):", #self.systems);
	for i, systemInfo in ipairs(self.systems) do
		self:WriteLine(systemInfo:GetSingleOutputLine());
	end
end

function APIDocumentationMixin:TryHandlingSystemSearchCommand(systemName, subCommand, apiToSearchFor)
	local system = self:FindSystemByName(systemName);
	if system then
		if subCommand == nil then
			self:WriteLine(system:GetSingleOutputLine());
		elseif subCommand == "s" or subCommand == "search" and apiToSearchFor then
			self:OutputAllSystemAPIMatches(system, apiToSearchFor);
		elseif subCommand == "list" then
			self:OutputAllSystemAPI(system);
		else
			self:OutputUsage();
		end
	else
		self:WriteLineF("No system found (%s)", tostring(systemName));
	end
end

function APIDocumentationMixin:OutputAPIMatches(apiMatches, headerName)
	if apiMatches and #apiMatches > 0 then
		self:WriteLineF("Found %d %s", #apiMatches, headerName);
		for i, api in ipairs(apiMatches) do
			self:WriteLine(self:GetIndentString() .. api:GetSingleOutputLine());
		end
	end
end

function APIDocumentationMixin:OutputAllAPIMatches(apiToSearchFor)
	if not apiToSearchFor or apiToSearchFor == "" then
		self:OutputUsage();
		return;
	end
	self:WriteLine(" ");

	local apiMatches = self:FindAllAPIMatches(apiToSearchFor);
	if apiMatches then
		local total = #apiMatches.tables + #apiMatches.functions + #apiMatches.systems;
		assert(total > 0);
		self:WriteLineF("Found %d API that matches %q", total, apiToSearchFor);

		self:OutputAPIMatches(apiMatches.systems, "system(s)");
		self:OutputAPIMatches(apiMatches.functions, "function(s)");
		self:OutputAPIMatches(apiMatches.tables, "table(s)");
	else
		self:WriteLineF("No API found that matches %q", apiToSearchFor);
	end
end

function APIDocumentationMixin:OutputAllSystemAPIMatches(system, apiToSearchFor)
	local apiMatches = system:FindAllAPIMatches(apiToSearchFor);
	if apiMatches then
		local total = #apiMatches.tables + #apiMatches.functions;
		assert(total > 0);
		self:WriteLineF("Found %d API that matches %q", total, apiToSearchFor);

		self:OutputAPIMatches(apiMatches.functions, "function(s)");
		self:OutputAPIMatches(apiMatches.tables, "table(s)");
	else
		self:WriteLineF("No API found that matches %q in %s", apiToSearchFor, system:GenerateAPILink());
	end
end

function APIDocumentationMixin:OutputAllSystemAPI(system)
	local apiMatches = system:ListAllAPI();
	if apiMatches then
		self:WriteLineF("All API in %s", system:GenerateAPILink());

		self:OutputAPIMatches(apiMatches.functions, "function(s)");
		self:OutputAPIMatches(apiMatches.tables, "table(s)");
	else
		self:WriteLineF("No API found in %s", system:GenerateAPILink());
	end
end

--[[static]] function APIDocumentationMixin:AddAllMatches(apiContainer, matchesContainer, apiToSearchFor)
	for i, apiInfo in ipairs(apiContainer) do
		if apiInfo:MatchesSearchString(apiToSearchFor) then
			table.insert(matchesContainer, apiInfo); 
		end
	end
end

function APIDocumentationMixin:FindAllAPIMatches(apiToSearchFor)
	apiToSearchFor = apiToSearchFor:lower();

	local matches = {
		tables = {},
		functions = {},
		systems = {},
	};

	self:AddAllMatches(self.tables, matches.tables, apiToSearchFor);
	self:AddAllMatches(self.functions, matches.functions, apiToSearchFor);
	self:AddAllMatches(self.systems, matches.systems, apiToSearchFor);

	-- Only return something if we matched anything
	for name, subTable in pairs(matches) do
		if #subTable > 0 then
			return matches;
		end
	end

	return nil;
end

function APIDocumentationMixin:FindSystemByName(systemName)
	systemName = systemName:lower();
	for i, systemInfo in ipairs(self.systems) do
		if systemInfo:MatchesNameCaseInsenstive(systemName) then
			return systemInfo;
		end
	end
	return nil;
end

function APIDocumentationMixin:AddDocumentationTable(documentationInfo)
	if documentationInfo.Name then
		self:AddSystem(documentationInfo);
	else
		for i, tableInfo in ipairs(documentationInfo.Tables) do
			self:AddTable(tableInfo);
		end
	end
end

function APIDocumentationMixin:WriteLine(message)
	local info = ChatTypeInfo["SYSTEM"];
	DEFAULT_CHAT_FRAME:AddMessage(message, info.r, info.g, info.b, info.id);
end

function APIDocumentationMixin:WriteLineF(format, ...)
	self:WriteLine(format:format(...));
end

function APIDocumentationMixin:WriteAllLines(lines)
	for i, line in ipairs(lines) do
		self:WriteLine(line);
	end
end

function APIDocumentationMixin:GetIndentString(numIndent)
	return ("   "):rep(numIndent or 1);
end

-- "private"
function APIDocumentationMixin:AddTable(documentationInfo)
	Mixin(documentationInfo, TablesAPIMixin);

	table.insert(self.tables, documentationInfo);

	if documentationInfo.Fields then
		for i, field in ipairs(documentationInfo.Fields) do
			field.Table = documentationInfo;
			self:AddField(field);
		end
	end
end

function APIDocumentationMixin:AddFunction(documentationInfo)
	Mixin(documentationInfo, FunctionsAPIMixin);

	table.insert(self.functions, documentationInfo);

	if documentationInfo.Arguments then
		for i, field in ipairs(documentationInfo.Arguments) do
			field.Function = documentationInfo;
			self:AddField(field);
		end
	end

	if documentationInfo.Returns then
		for i, field in ipairs(documentationInfo.Returns) do
			field.Function = documentationInfo;
			self:AddField(field);
		end
	end
end

function APIDocumentationMixin:AddField(documentationInfo)
	Mixin(documentationInfo, FieldsAPIMixin);

	table.insert(self.fields, documentationInfo);
end

function APIDocumentationMixin:AddSystem(documentationInfo)
	Mixin(documentationInfo, SystemsAPIMixin);

	table.insert(self.systems, documentationInfo);

	for i, functionInfo in ipairs(documentationInfo.Functions) do
		functionInfo.System = documentationInfo;
		self:AddFunction(functionInfo);
	end

	for i, tableInfo in ipairs(documentationInfo.Tables) do
		tableInfo.System = documentationInfo;
		self:AddTable(tableInfo);
	end
end

APIDocumentation = CreateFromMixins(APIDocumentationMixin);
APIDocumentation:OnLoad();