# Requirements Document

## Introduction

This feature implements a visual score animation system that enhances player feedback when transitioning from phase 2 (jumping/height phase) back to phase 1 (ground phase). The system will animate the combination of the phase 2 height score with the current combo multiplier, then visually move this calculated score to the main score display in the top right corner. This provides satisfying visual feedback while maintaining gameplay flow during the critical falling/landing sequence.

## Requirements

### Requirement 1

**User Story:** As a player, I want to see my phase 2 height score combine with my combo multiplier in a clear visual way, so that I understand how my performance is being calculated and rewarded.

#### Acceptance Criteria

1. WHEN the player transitions from phase 2 to phase 1 THEN the system SHALL capture the current phase 2 height score value
2. WHEN the phase transition occurs THEN the system SHALL capture the current combo multiplier value from the top left display
3. WHEN both values are captured THEN the system SHALL calculate the final score (height score × combo multiplier)
4. IF the combo multiplier is greater than 1 THEN the system SHALL display a visual multiplication animation showing the calculation
5. WHEN the multiplication animation completes THEN the system SHALL display the final calculated score value

### Requirement 2

**User Story:** As a player, I want the calculated score to smoothly animate from its current position to the main score display, so that I can visually track where my points are going.

#### Acceptance Criteria

1. WHEN the score calculation is complete THEN the system SHALL animate the score value moving from the phase 2 score position to the top right corner
2. WHEN the score animation starts THEN the system SHALL use a smooth trajectory that doesn't obstruct critical gameplay areas
3. WHEN the animated score reaches the top right corner THEN the system SHALL trigger a contact/impact effect
4. WHEN the contact effect occurs THEN the system SHALL make the animated score disappear
5. WHEN the animated score disappears THEN the system SHALL update the main score display with the new total

### Requirement 3

**User Story:** As a player, I want the score animation to provide satisfying feedback without interfering with my gameplay, so that I can focus on landing safely while still enjoying the visual reward.

#### Acceptance Criteria

1. WHEN the score animation is playing THEN the system SHALL allow normal player input and movement
2. WHEN the player is falling and trying to land THEN the animation SHALL NOT obstruct the player's view of critical landing areas
3. WHEN the score reaches the main display THEN the system SHALL provide visual feedback (such as jitter or scaling) to emphasize the score addition
4. WHEN the animation completes THEN the system SHALL ensure the main score display shows the correct updated total
5. IF multiple score animations need to play simultaneously THEN the system SHALL handle them without performance degradation

### Requirement 4

**User Story:** As a player, I want the animation timing to feel responsive and appropriately paced, so that the feedback feels immediate but not rushed or distracting.

#### Acceptance Criteria

1. WHEN the phase transition occurs THEN the multiplication animation SHALL start within 0.1 seconds
2. WHEN the multiplication animation plays THEN it SHALL complete within 0.5-1.0 seconds
3. WHEN the score movement animation starts THEN it SHALL take 0.8-1.5 seconds to reach the main display
4. WHEN the score impacts the main display THEN the impact effect SHALL last 0.2-0.4 seconds
5. WHEN all animations complete THEN the total animation sequence SHALL not exceed 3 seconds

### Requirement 5

**User Story:** As a developer, I want the animation system to integrate cleanly with existing game phases and UI elements, so that it doesn't break current functionality or create maintenance issues.

#### Acceptance Criteria

1. WHEN phase 2 ends THEN the system SHALL properly clean up the phase 2 score display as before
2. WHEN phase 1 begins THEN the main score display SHALL appear as normal but be ready to receive animated score updates
3. WHEN the animation system activates THEN it SHALL NOT interfere with existing combo display functionality in the top left
4. WHEN the animation completes THEN all UI elements SHALL return to their normal phase 1 state
5. IF the animation system fails THEN the game SHALL fall back to the current behavior of updating the score without animation