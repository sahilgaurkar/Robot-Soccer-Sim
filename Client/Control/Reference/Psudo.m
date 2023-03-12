


aTarget = 100;
aCurrent = 10;
aVelocity = 0;
aTimeStep = 1;

SPRING_CONSTANT = 1;

for i = 1:1:10

currentToTarget = aTarget - aCurrent;
springForce = currentToTarget * SPRING_CONSTANT;
dampingForce = -aVelocity * 2 * sqrt( SPRING_CONSTANT );
force = springForce + dampingForce;
aVelocity = aVelocity + force * aTimeStep;
displacement = aVelocity * aTimeStep

end
