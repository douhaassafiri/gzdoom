// A passive ambient spirit that floats and wanders aimlessly.
// Adds atmospheric life to the level without engaging the player.
class WandererSoul : LostSoul replaces LostSoul
{
    // Can move through walls, floats in the air vertically, and is translucent. Does not attack or harm the player.
    Default
    {
        +NOCLIP
        +NOGRAVITY
        +FLOAT
        +LOOKALLAROUND
        +FRIENDLY
        Speed 2;
        RenderStyle "Translucent";
        Alpha 0.5;
        Radius 16;
        Height 56;
        Health 100;
        SeeSound "none";
        AttackSound "none";
    }

    // Called every frame. Controls random wandering logic.
    override void Tick()
    {
        super.Tick();

        // Change direction randomly every 30 ticks 
        if (level.time % 30 == 0)
        {
            angle = Random(0, 255) * 256; // Random angle in full circle
            vel.X = cos(angle) * Speed;
            vel.Y = sin(angle) * Speed;
        }
    }

    States
    {
    // Passive spawn state with idle animation
    Spawn:
        SKUL A 6 A_Look;
        Loop;

    // Redirect See to Spawn since there's no active chasing
    See:
        Goto Spawn;
    }
}
