/*
 * Author: Glowbal
 * Calculates the blood volume change and decreases the IVs given to the unit.
 *
 * Arguments:
 * 0: The Unit <OBJECT>
 *
 * ReturnValue:
 * Current cardiac output <NUMBER>
 *
 * Public: No
 */

#include "script_component.hpp"

/*
    IV Change per second calculation:
    250ml should take 60 seconds to fill. 250/60 = 4.166.
*/
#define IV_CHANGE_PER_SECOND         -4.166

/*
    Blood Change per second calculation for IVs:
    250ml should take 60 seconds to fill in. Total blood volume is 7000ml = 100%.
    7000/100 = 70 = 1%
    250 / 70 = 3.571428571%
    3.571428571 / 60 = 0.0595% per second.
*/
#define BLOOD_CHANGE_PER_SECOND        0.0595

#define EMPTY_IV_BAG_VALUE 0
#define IV_VOLUME (_unit getVariable [_x, EMPTY_IV_BAG_VALUE]) + IV_CHANGE_PER_SECOND

private ["_bloodVolume", "_bloodVolumeChange", "_ivVolume"];
params ["_unit"];

private _bloodVolume = _unit getVariable [QGVAR(bloodVolume), 100];
private _bloodVolumeChange = -([_unit] call FUNC(getBloodLoss));

if (_bloodVolume < 100) then {
    {
        if ((_unit getVariable [_x, EMPTY_IV_BAG_VALUE]) > EMPTY_IV_BAG_VALUE) then {
            _bloodVolumeChange = _bloodVolumeChange + BLOOD_CHANGE_PER_SECOND;
            _unit setVariable [_x, IV_VOLUME];
        };
    } forEach GVAR(IVBags);
} else {
    {
        if ((_unit getVariable [_x, EMPTY_IV_BAG_VALUE]) > EMPTY_IV_BAG_VALUE) then {
            _unit setVariable [_x, EMPTY_IV_BAG_VALUE]; // lets get rid of exessive IV volume
        };
    } forEach GVAR(IVBags);
};

_bloodVolumeChange;
