// A custom AI class that extends the base ZombieMan actor
// This zombie patrols between up to 4 placed PatrolPoint actors in the map
class PatrolZombie : ZombieMan
{
    // Array to store up to 4 patrol points found on the map
    Actor patrolPoints[4];
    // Tracks the current patrol point index
    int currentPoint;

    // Called once after the actor is spawned into the game world
    override void PostBeginPlay()
    {
        super.PostBeginPlay();

        // Search for actors of class "PatrolPoint" and store references to them
        int i = 0;
        let it = ThinkerIterator.Create("PatrolPoint");
        Actor a;
        while ((a = Actor(it.Next())) != null && i < 4)
        {
            patrolPoints[i++] = a;
        }

        // Start at the first patrol point
        currentPoint = 0;
        // Enter the custom patrol state
        SetStateLabel("Patrol");
    }

    // State machine for AI behavior
    States
    {
    Patrol:
        TNT1 A 0
        {
            // Get the current patrol goal
            let goal = patrolPoints[currentPoint];
            if (goal != null)
            {
                // Calculate the squared distance to the patrol point
                double dx = goal.Pos.X - Pos.X;
                double dy = goal.Pos.Y - Pos.Y;
                double distSq = dx * dx + dy * dy;

                // If close to the goal, advance to the next patrol point
                if (distSq < 64)
                {
                    currentPoint = (currentPoint + 1) % 4;
                }
                else
                {
                    // Turn to face the goal
                    double ang = vectorangle(dx, dy);
                    angle = ang;
                    // Move toward the patrol point
                    vel.X = cos(ang) * 1.5;
                    vel.Y = sin(ang) * 1.5;
                }
            }
        }
         // Vision cone check for player detection
        TNT1 A 2 A_LookEx(LOF_NOSOUNDCHECK, 32, 30);

        // Play the walk animation while patrolling
        ZOMB AABBCCDD 4;

        // Loop back to continue patrolling
        Goto Patrol;

    See:
        // Standard zombie chase logic when a target is acquired
        ZOMB AABBCCDD 4 A_Chase;
        Loop;
    }
}
