--Dx Functions
local dxDrawLine = dxDrawLine
local dxDrawImage = dxDrawImageExt
local dxDrawImageSection = dxDrawImageSectionExt
local dxDrawText = dxDrawText
local dxGetFontHeight = dxGetFontHeight
local dxDrawRectangle = dxDrawRectangle
local dxSetShaderValue = dxSetShaderValue
local dxGetPixelsSize = dxGetPixelsSize
local dxGetPixelColor = dxGetPixelColor
local dxSetRenderTarget = dxSetRenderTarget
local dxGetTextWidth = dxGetTextWidth
local dxSetBlendMode = dxSetBlendMode

local getScreenFromWorldPosition = getScreenFromWorldPosition

function dgsCreate3DText(x,y,z,text,color,font,sizeX,sizeY,maxDistance,colorcoded)
	assert(type(x) == "number","Bad argument @dgsCreate3DText at argument 1, expect a number got "..type(x))
	assert(type(y) == "number","Bad argument @dgsCreate3DText at argument 2, expect a number got "..type(y))
	assert(type(y) == "number","Bad argument @dgsCreate3DText at argument 3, expect a number got "..type(z))
	local text3d = createElement("dgs-dx3dtext")
	table.insert(dx3DTextTable,text3d)
	dgsSetType(text3d,"dgs-dx3dtext")
	dgsSetData(text3d,"renderBuffer",{})
	dgsSetData(text3d,"position",{x,y,z})
	dgsSetData(text3d,"textSize",{sizeX or 1,sizeY or 1})
	dgsSetData(text3d,"fixTextSize",false)
	dgsSetData(text3d,"font",font or styleSettings.text3D.font or systemFont)
	dgsSetData(text3d,"color",color or tocolor(255,255,255,255))
	dgsSetData(text3d,"maxDistance",maxDistance or 80)
	dgsSetData(text3d,"fadeDistance",maxDistance or 80)
	dgsSetData(text3d,"dimension",-1)
	dgsSetData(text3d,"interior",-1)
	dgsSetData(text3d,"canBeBlocked",false)
	dgsSetData(text3d,"subPixelPositioning",true)
	dgsAttachToTranslation(text3d,resourceTranslation[sourceResource or getThisResource()])
	if type(text) == "table" then
		dgsElementData[text3d]._translationText = text
		dgsSetData(text3d,"text",text)
	else
		dgsSetData(text3d,"text",tostring(text))
	end
	dgsSetData(text3d,"colorcoded",colorcoded or false)
	triggerEvent("onDgsCreate",text3d,sourceResource)
	return text3d
end

function dgs3DTextGetDimension(text)
	assert(dgsGetType(text) == "dgs-dx3dtext","Bad argument @dgs3DTextGetDimension at argument 1, expect a dgs-dx3dtext got "..dgsGetType(text))
	return dgsElementData[text].dimension or -1
end

function dgs3DTextSetDimension(text,dimension)
	assert(dgsGetType(text) == "dgs-dx3dtext","Bad argument @dgs3DTextSetDimension at argument 1, expect a dgs-dx3dtext got "..dgsGetType(text))
	assert(type(dimension) == "number","Bad argument @dgs3DTextSetDimension at argument 2, expect a number got "..type(dimension))
	assert(dimension >= -1 and dimension <= 65535,"Bad argument @dgs3DTextSetDimension at argument 2, out of range [0~65535] got "..dimension)
	return dgsSetData(text,"dimension",dimension-dimension%1)
end

function dgs3DTextGetInterior(text)
	assert(dgsGetType(text) == "dgs-dx3dtext","Bad argument @dgs3DTextGetInterior at argument 1, expect a dgs-dx3dtext got "..dgsGetType(text))
	return dgsElementData[text].interior or -1
end

function dgs3DTextSetInterior(text,interior)
	assert(dgsGetType(text) == "dgs-dx3dtext","Bad argument @dgs3DTextSetInterior at argument 1, expect a dgs-dx3dtext got "..dgsGetType(text))
	assert(type(interior) == "number","Bad argument @dgs3DTextSetInterior at argument 2, expect a number got "..type(interior))
	assert(interior >= -1,"Bad argument @dgs3DTextSetInterior at argument 2, out of range [ -1 ~ +∞ ] got "..interior)
	return dgsSetData(text,"interior",interior-interior%1)
end

function dgs3DTextAttachToElement(text,element,offX,offY,offZ)
	assert(dgsGetType(text) == "dgs-dx3dtext","Bad argument @dgs3DTextAttachToElement at argument 1, expect a dgs-dx3dtext got "..dgsGetType(text))
	assert(isElement(element),"Bad argument @dgs3DTextAttachToElement at argument 2, expect an element got "..dgsGetType(element))
	local offX,offY,offZ = offX or 0,offY or 0,offZ or 0
	return dgsSetData(text,"attachTo",{element,offX,offY,offZ})
end

function dgs3DTextIsAttached(text)
	assert(dgsGetType(text) == "dgs-dx3dtext","Bad argument @dgs3DTextIsAttached at argument 1, expect a dgs-dx3dtext got "..dgsGetType(text))
	return dgsElementData[text].attachTo
end

function dgs3DTextDetachFromElement(text)
	assert(dgsGetType(text) == "dgs-dx3dtext","Bad argument @dgs3DTextDetachFromElement at argument 1, expect a dgs-dx3dtext got "..dgsGetType(text))
	return dgsSetData(text,"attachTo",false)
end

function dgs3DTextSetAttachedOffsets(text,offX,offY,offZ)
	assert(dgsGetType(text) == "dgs-dx3dtext","Bad argument @dgs3DTextSetAttachedOffsets at argument 1, expect a dgs-dx3dtext got "..dgsGetType(text))
	local attachTable = dgsElementData[text].attachTo
	if attachTable then
		local offX,offY,offZ = offX or attachTable[2],offY or attachTable[3],offZ or attachTable[4]
		return dgsSetData(text,"attachTo",{attachTable[1],offX,offY,offZ})
	end
	return false
end

function dgs3DTextGetAttachedOffsets(text,offX,offY,offZ)
	assert(dgsGetType(text) == "dgs-dx3dtext","Bad argument @dgs3DTextGetAttachedOffsets at argument 1, expect a dgs-dx3dtext got "..dgsGetType(text))
	local attachTable = dgsElementData[text].attachTo
	if attachTable then
		local offX,offY,offZ = attachTable[2],attachTable[3],attachTable[4]
		return offX,offY,offZ
	end
	return false
end

function dgs3DTextSetPosition(text,x,y,z)
	assert(dgsGetType(text) == "dgs-dx3dtext","Bad argument @dgs3DTextSetPosition at argument 1, expect a dgs-dx3dtext got "..dgsGetType(text))
	assert(type(x) == "number","Bad argument @dgs3DTextSetPosition at argument 2, expect a number got "..type(x))
	assert(type(y) == "number","Bad argument @dgs3DTextSetPosition at argument 3, expect a number got "..type(y))
	assert(type(z) == "number","Bad argument @dgs3DTextSetPosition at argument 4, expect a number got "..type(z))
	return dgsSetData(text,"position",{x,y,z})
end

function dgs3DTextGetPosition(text)
	assert(dgsGetType(text) == "dgs-dx3dtext","Bad argument @dgs3DTextGetPosition at argument 1, expect a dgs-dx3dtext got "..dgsGetType(text))
	local pos = dgsElementData[text].position
	return pos[1],pos[2],pos[3]
end

----------------------------------------------------------------
--------------------------Renderer------------------------------
----------------------------------------------------------------

local g_canBeBlocked = {
	checkBuildings = true,
	checkVehicles = true,
	checkPeds = true,
	checkObjects = true,
	checkDummies = true,
	seeThroughStuff = false,
	ignoreSomeObjectsForCamera = false,
}
dgsRenderer["dgs-dx3dtext"] = function(source,x,y,w,h,mx,my,cx,cy,enabled,eleData,parentAlpha,isPostGUI,rndtgt)
	local attachTable = eleData.attachTo
	local posTable = eleData.position
	local wx,wy,wz = posTable[1],posTable[2],posTable[3]
	local isRender = true
	if attachTable then
		if isElement(attachTable[1]) then
			if isElementStreamedIn(attachTable[1]) then
				wx,wy,wz = getPositionFromElementOffset(attachTable[1],attachTable[2],attachTable[3],attachTable[4])
				eleData.position = {wx,wy,wz}
			else
				isRender = false
			end
		else
			eleData.attachTo = false
		end
	end
	if isRender then
		local camX,camY,camZ = getCameraMatrix()
		local maxDistance = eleData.maxDistance
		local distance = ((wx-camX)^2+(wy-camY)^2+(wz-camZ)^2)^0.5
		if distance <= maxDistance and distance > 0 then
			local canBeBlocked = eleData.canBeBlocked
			if canBeBlocked then
				if canBeBlocked == true then
					canBeBlocked = g_canBeBlocked
				end
				tmpCanBeBlocked = {
					checkBuildings = canBeBlocked.checkBuildings ~= nil and canBeBlocked.checkBuildings or g_canBeBlocked.checkBuildings
					checkVehicles = canBeBlocked.checkVehicles ~= nil and canBeBlocked.checkVehicles or g_canBeBlocked.checkVehicles
					checkPeds = canBeBlocked.checkPeds ~= nil and canBeBlocked.checkPeds or g_canBeBlocked.checkPeds
					checkObjects = canBeBlocked.checkObjects ~= nil and canBeBlocked.checkObjects or g_canBeBlocked.checkObjects
					checkDummies = canBeBlocked.checkDummies ~= nil and canBeBlocked.checkDummies or g_canBeBlocked.checkDummies
					seeThroughStuff = canBeBlocked.seeThroughStuff ~= nil and canBeBlocked.seeThroughStuff or g_canBeBlocked.seeThroughStuff
					ignoreSomeObjectsForCamera = canBeBlocked.ignoreSomeObjectsForCamera ~= nil and canBeBlocked.ignoreSomeObjectsForCamera or g_canBeBlocked.ignoreSomeObjectsForCamera
				}
				canBeBlocked = tmpCanBeBlocked
			end
			local textSizeX,textSizeY = eleData.textSize[1],eleData.textSize[2]
			local colorcoded = eleData.colorcoded
			local fadeDistance = eleData.fadeDistance
			local text = eleData.text
			local font = eleData.font or systemFont
			local subPixelPositioning = eleData.subPixelPositioning
			if (not canBeBlocked or (canBeBlocked and isLineOfSightClear(wx, wy, wz, camX, camY, camZ, canBeBlocked.checkBuildings, canBeBlocked.checkVehicles, canBeBlocked.checkPeds, canBeBlocked.checkObjects, canBeBlocked.checkDummies, canBeBlocked.seeThroughStuff,canBeBlocked.ignoreSomeObjectsForCamera))) then
				local fadeMulti = 1
				if maxDistance > fadeDistance and distance >= fadeDistance then
					fadeMulti = 1-(distance-fadeDistance)/(maxDistance-fadeDistance)
				end
				local x,y = getScreenFromWorldPosition(wx,wy,wz,0.5)
				if x and y then
					local x,y = x-x%1,y-y%1
					if eleData.fixTextSize then
						distance = 50
					end
					local antiDistance = 1/distance
					local sizeX = textSizeX*textSizeX/distance*50
					local sizeY = textSizeY*textSizeY/distance*50
					local color = applyColorAlpha(eleData.color,parentAlpha*fadeMulti)
					local shadow = eleData.shadow
					if shadow then
						local shadowoffx,shadowoffy,shadowc,shadowIsOutline = shadow[1],shadow[2],shadow[3],shadow[4]
						if shadowoffx and shadowoffy and shadowc then
							local shadowText = text
							if colorcoded then
								shadowText = text:gsub('#%x%x%x%x%x%x','').."\n"
							end
							local shadowc = applyColorAlpha(shadowc,parentAlpha*fadeMulti)
							local shadowoffx,shadowoffy = shadowoffx*antiDistance*50,shadowoffy*antiDistance*50
							dxDrawText(shadowText,x+shadowoffx,y+shadowoffy,_,_,shadowc,sizeX,sizeY,font,"center","center",false,false,false,false,subPixelPositioning)
							if shadowIsOutline then
								dxDrawText(shadowText,x-shadowoffx,y+shadowoffy,_,_,shadowc,sizeX,sizeY,font,"center","center",false,false,false,false,subPixelPositioning)
								dxDrawText(shadowText,x-shadowoffx,y-shadowoffy,_,_,shadowc,sizeX,sizeY,font,"center","center",false,false,false,false,subPixelPositioning)
								dxDrawText(shadowText,x+shadowoffx,y-shadowoffy,_,_,shadowc,sizeX,sizeY,font,"center","center",false,false,false,false,subPixelPositioning)
							end
						end
					end
					dxDrawText(text,x,y,x,y,color,sizeX,sizeY,font,"center","center",false,false,false,colorcoded,subPixelPositioning)
					------------------------------------OutLine
					local outlineData = eleData.outline
					if outlineData then
						local shadowText = colorcoded and text:gsub('#%x%x%x%x%x%x','') or text
						local w,h = dxGetTextWidth(shadowText,sizeX,font),dxGetFontHeight(sizeY,font)
						local x,y=x-w*0.5,y-h*0.5
						local sideColor = outlineData[3]
						local sideSize = outlineData[2]*antiDistance*25
						local hSideSize = sideSize*0.5
						sideColor = applyColorAlpha(sideColor,parentAlpha*fadeMulti)
						local side = outlineData[1]
						if side == "in" then
							dxDrawLine(x,y+hSideSize,x+w,y+hSideSize,sideColor,sideSize)
							dxDrawLine(x+hSideSize,y,x+hSideSize,y+h,sideColor,sideSize)
							dxDrawLine(x+w-hSideSize,y,x+w-hSideSize,y+h,sideColor,sideSize)
							dxDrawLine(x,y+h-hSideSize,x+w,y+h-hSideSize,sideColor,sideSize)
						elseif side == "center" then
							dxDrawLine(x-hSideSize,y,x+w+hSideSize,y,sideColor,sideSize)
							dxDrawLine(x,y+hSideSize,x,y+h-hSideSize,sideColor,sideSize)
							dxDrawLine(x+w,y+hSideSize,x+w,y+h-hSideSize,sideColor,sideSize)
							dxDrawLine(x-hSideSize,y+h,x+w+hSideSize,y+h,sideColor,sideSize)
						elseif side == "out" then
							dxDrawLine(x-sideSize,y-hSideSize,x+w+sideSize,y-hSideSize,sideColor,sideSize)
							dxDrawLine(x-hSideSize,y,x-hSideSize,y+h,sideColor,sideSize)
							dxDrawLine(x+w+hSideSize,y,x+w+hSideSize,y+h,sideColor,sideSize)
							dxDrawLine(x-sideSize,y+h+hSideSize,x+w+sideSize,y+h+hSideSize,sideColor,sideSize)
						end
					end
				end
			end
		end
	end
	return rndtgt,true
end
