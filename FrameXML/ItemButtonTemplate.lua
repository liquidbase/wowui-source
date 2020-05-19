function GetFormattedItemQuantity(quantity, maxQuantity)
	if quantity > (maxQuantity or 9999) then
		return "*";
	end;

	return quantity;
end

function SetItemButtonCount(button, count, abbreviate)
	if ( not button ) then
		return;
	end

	if ( not count ) then
		count = 0;
	end

	button.count = count;
	local countString = button.Count or _G[button:GetName().."Count"];
	if ( count > 1 or (button.isBag and count > 0) ) then
		if ( abbreviate ) then
			count = AbbreviateNumbers(count);
		else
			count = GetFormattedItemQuantity(count, button.maxDisplayCount);
		end

		countString:SetText(count);
		countString:SetTextColor(HIGHLIGHT_FONT_COLOR:GetRGB());
		countString:Show();
	else
		countString:Hide();
	end
end

function GetItemButtonCount(button)
	return button.count;
end

function SetItemButtonStock(button, numInStock)
	if ( not button ) then
		return;
	end

	if ( not numInStock ) then
		numInStock = "";
	end

	button.numInStock = numInStock;
	if ( numInStock > 0 ) then
		_G[button:GetName().."Stock"]:SetFormattedText(MERCHANT_STOCK, numInStock);
		_G[button:GetName().."Stock"]:Show();
	else
		_G[button:GetName().."Stock"]:Hide();
	end
end

function SetItemButtonTexture(button, texture)
	if ( not button ) then
		return;
	end
	
	local icon = button.Icon or button.icon or _G[button:GetName().."IconTexture"];
	if ( texture ) then
		icon:Show();
	else
		icon:Hide();
	end

	icon:SetTexture(texture);
end

function SetItemButtonTextureVertexColor(button, r, g, b)
	if ( not button ) then
		return;
	end
	
	local icon = button.Icon or button.icon or _G[button:GetName().."IconTexture"];
	icon:SetVertexColor(r, g, b);
end

function SetItemButtonDesaturated(button, desaturated)
	if ( not button ) then
		return;
	end
	local icon = button.Icon or button.icon or _G[button:GetName().."IconTexture"];
	if ( not icon ) then
		return;
	end
	
	icon:SetDesaturated(desaturated);
end

function SetItemButtonNormalTextureVertexColor(button, r, g, b)
	if ( not button ) then
		return;
	end
	
	_G[button:GetName().."NormalTexture"]:SetVertexColor(r, g, b);
end

function SetItemButtonNameFrameVertexColor(button, r, g, b)
	if ( not button ) then
		return;
	end
	
	local nameFrame = button.NameFrame or _G[button:GetName().."NameFrame"];
	nameFrame:SetVertexColor(r, g, b);
end

function SetItemButtonSlotVertexColor(button, r, g, b)
	if ( not button ) then
		return;
	end
	
	_G[button:GetName().."SlotTexture"]:SetVertexColor(r, g, b);
end

function SetItemButtonQuality(button, quality, itemIDOrLink, suppressOverlays)
	if button.useCircularIconBorder then
		button.IconBorder:Show();

		if quality == LE_ITEM_QUALITY_POOR then
			button.IconBorder:SetAtlas("auctionhouse-itemicon-border-gray");
		elseif quality == LE_ITEM_QUALITY_COMMON then
			button.IconBorder:SetAtlas("auctionhouse-itemicon-border-white");
		elseif quality == LE_ITEM_QUALITY_UNCOMMON then
			button.IconBorder:SetAtlas("auctionhouse-itemicon-border-green");
		elseif quality == LE_ITEM_QUALITY_RARE then
			button.IconBorder:SetAtlas("auctionhouse-itemicon-border-blue");
		elseif quality == LE_ITEM_QUALITY_EPIC then
			button.IconBorder:SetAtlas("auctionhouse-itemicon-border-purple");
		elseif quality == LE_ITEM_QUALITY_LEGENDARY then
			button.IconBorder:SetAtlas("auctionhouse-itemicon-border-orange");
		elseif quality == LE_ITEM_QUALITY_ARTIFACT then
			button.IconBorder:SetAtlas("auctionhouse-itemicon-border-artifact");
		elseif quality == LE_ITEM_QUALITY_HEIRLOOM then
			button.IconBorder:SetAtlas("auctionhouse-itemicon-border-account");
		elseif quality == LE_ITEM_QUALITY_WOW_TOKEN then
			button.IconBorder:SetAtlas("auctionhouse-itemicon-border-account");
		else
			button.IconBorder:Hide();
		end
		
		return;
	end

	if itemIDOrLink then
		if IsArtifactRelicItem(itemIDOrLink) then
			button.IconBorder:SetTexture([[Interface\Artifacts\RelicIconFrame]]);
		else
			button.IconBorder:SetTexture([[Interface\Common\WhiteIconFrame]]);
		end
		
		button.IconOverlay:Hide();
		if not suppressOverlays then
			if C_AzeriteEmpoweredItem.IsAzeriteEmpoweredItemByID(itemIDOrLink) then
				button.IconOverlay:SetAtlas("AzeriteIconFrame");
				button.IconOverlay:Show();
			elseif IsCorruptedItem(itemIDOrLink) then
				button.IconOverlay:SetAtlas("Nzoth-inventory-icon");
				button.IconOverlay:Show();
			end
		end
	else
		button.IconBorder:SetTexture([[Interface\Common\WhiteIconFrame]]);
		button.IconOverlay:Hide();
	end

	if quality then
		if quality >= LE_ITEM_QUALITY_COMMON and BAG_ITEM_QUALITY_COLORS[quality] then
			button.IconBorder:Show();
			button.IconBorder:SetVertexColor(BAG_ITEM_QUALITY_COLORS[quality].r, BAG_ITEM_QUALITY_COLORS[quality].g, BAG_ITEM_QUALITY_COLORS[quality].b);
		else
			button.IconBorder:Hide();
		end
	else
		button.IconBorder:Hide();
	end
end

function HandleModifiedItemClick(link)
	if ( not link ) then
		return false;
	end
	if ( IsModifiedClick("CHATLINK") ) then
		local linkType = string.match(link, "|H([^:]+)");
		if ( linkType == "instancelock" ) then	--People can't re-link instances that aren't their own.
			local guid = string.match(link, "|Hinstancelock:([^:]+)");
			if ( not string.find(UnitGUID("player"), guid) ) then
				return true;
			end
		end
		if ( ChatEdit_InsertLink(link) ) then
			return true;
		elseif ( SocialPostFrame and Social_IsShown() ) then
			Social_InsertLink(link);
			return true;
		end
	end
	if ( IsModifiedClick("DRESSUP") ) then
		return DressUpItemLink(link) or DressUpBattlePetLink(link) or DressUpMountLink(link)
	end
	if ( IsModifiedClick("EXPANDITEM") ) then
		if C_AzeriteEmpoweredItem.IsAzeriteEmpoweredItemByID(link) then
			OpenAzeriteEmpoweredItemUIFromLink(link);
			return true;
		end
	end
	return false;
end

ItemButtonMixin = {};

function ItemButtonMixin:PostOnLoad()
	self.itemContextChangedCallback = function()
		self:UpdateItemContextMatching();
	end
end

function ItemButtonMixin:RegisterCallback()
	if not self.itemContextChangedCallbackIsSet then
		ItemButtonUtil.RegisterCallback(ItemButtonUtil.Event.ItemContextChanged, self.itemContextChangedCallback);
		self.itemContextChangedCallbackIsSet = true;
	end
end

function ItemButtonMixin:UnregisterCallback()
	if self.itemContextChangedCallbackIsSet then
		ItemButtonUtil.UnregisterCallback(ItemButtonUtil.Event.ItemContextChanged, self.itemContextChangedCallback);
		self.itemContextChangedCallbackIsSet = false;
	end
end

function ItemButtonMixin:PostOnShow()
	self:UpdateItemContextMatching();
	
	local hasFunctionSet = self.GetItemContextMatchResult ~= nil;
	if hasFunctionSet then
		self:RegisterCallback();
	end
end

function ItemButtonMixin:PostOnHide()
	self:UnregisterCallback();
end

function ItemButtonMixin:SetMatchesSearch(matchesSearch)
	self.matchesSearch = matchesSearch;
	self:UpdateItemContextOverlay(self);
end

function ItemButtonMixin:GetMatchesSearch()
	return self.matchesSearch;
end

function ItemButtonMixin:UpdateItemContextMatching()
	local hasFunctionSet = self.GetItemContextMatchResult ~= nil;
	if hasFunctionSet then
		self.itemContextMatchResult = self:GetItemContextMatchResult();
	else
		self.itemContextMatchResult = ItemButtonUtil.ItemContextMatchResult.DoesNotApply;
	end
	
	self:UpdateItemContextOverlay(self);
end

function ItemButtonMixin:UpdateItemContextOverlay()
	local matchesSearch = self.matchesSearch == nil or self.matchesSearch;
	local matchesContext = self.itemContextMatchResult == ItemButtonUtil.ItemContextMatchResult.DoesNotApply or self.itemContextMatchResult == ItemButtonUtil.ItemContextMatchResult.Match;
	self.ItemContextOverlay:SetShown(not matchesSearch or not matchesContext);
end
