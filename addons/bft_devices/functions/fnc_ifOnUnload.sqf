/*
 * Author: Gundy
 *
 * Description:
 *   Closes the currently open interface and remove any previously registered eventhandlers
 *
 * Arguments:
 *   NONE
 *
 * Return Value:
 *   TRUE <BOOL>
 *
 * Example:
 *   [] call ace_bft_devices_ifOnload;
 *
 * Public: No
 */

#include "script_component.hpp"

private ["_displayName","_mapScale","_ifType","_player","_playerKilledEhId","_vehicle","_vehicleGetOutEhId","_draw3dEhId","_aceUnconciousEhId","_acePlayerInventoryChangedEhId","_acePlayerChangedEhId"];

// remove helmet and UAV cameras
//[] call FUNC(deleteHelmetCam);
//[] call FUNC(deleteUAVcam);

if !(isNil QGVAR(ifOpen)) then {
    // [_ifType,_displayName,_player,_playerKilledEhId,_vehicle,_vehicleGetOutEhId]
    _ifType = GVAR(ifOpen) select 0;
    _displayName = GVAR(ifOpen) select 1;
    _player = GVAR(ifOpen) select 2;
    _playerKilledEhId = GVAR(ifOpen) select 3;
    _vehicle = GVAR(ifOpen) select 4;
    _vehicleGetOutEhId = GVAR(ifOpen) select 5;
    _draw3dEhId = GVAR(ifOpen) select 6;
    _aceUnconciousEhId = GVAR(ifOpen) select 7;
    _acePlayerInventoryChangedEhId = GVAR(ifOpen) select 8;
    _acePlayerChangedEhId = GVAR(ifOpen) select 9;
    
    uiNamespace setVariable [_displayName, displayNull];
    
    if (!isNil "_playerKilledEhId") then {_player removeEventHandler ["killed",_playerKilledEhId]};
    if (!isNil "_vehicleGetOutEhId") then {_vehicle removeEventHandler ["GetOut",_vehicleGetOutEhId]};
    if (!isNil "_draw3dEhId") then {removeMissionEventHandler ["Draw3D",_draw3dEhId]};
    if (!isNil "_aceUnconciousEhId") then {["medical_onUnconscious",_aceUnconciousEhId] call EFUNC(common,removeEventHandler)};
    if (!isNil "_acePlayerInventoryChangedEhId") then {["playerInventoryChanged",_acePlayerInventoryChangedEhId] call EFUNC(common,removeEventHandler)};
    if (!isNil "_acePlayerChangedEhId") then {["playerChanged",_acePlayerChangedEhId] call EFUNC(common,removeEventHandler)};
    
    // don't call this part if we are closing down before setup has finished
    if (!GVAR(ifOpenStart)) then {
        // Save mapWorldPos and mapScaleDlg of current dialog so it can be restored later
        if ([_displayName] call FUNC(isDialog)) then {
            _mapScale = GVAR(mapScale) * GVAR(mapScaleFactor) / 0.86 * (safezoneH * 0.8);
            [_displayName,[["mapWorldPos",GVAR(mapWorldPos)],["mapScaleDlg",_mapScale]],false] call FUNC(setSettings);
        };
    };
    
    GVAR(ifOpen) = nil;
};

GVAR(cursorOnMap) = false;
GVAR(ifOpenStart) = false;

true