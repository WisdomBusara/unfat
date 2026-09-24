# Comprehensive Fitness, Weight Management, Body Composition, Combat, Recovery & Traditional Practices App

## Master Product Requirements, Research Taxonomy, Evidence Framework and Feature Specification

**Document status:** Master specification\
**Purpose:** Consolidate the complete research and product scope into
one evidence-aware fitness and wellness application.\
**Scope:** Weight management, fat loss, muscle gain/bulking, body
recomposition, fitness, exercise, calisthenics, combat sports,
self-defence education, traditional and complementary practices,
lymphatic health, nutrition, sleep, stress/cortisol, recovery, behavior
change, apps, wearables and long-term adherence.

------------------------------------------------------------------------

# 1. Product Vision

Build a comprehensive fitness and wellness application that does not
reduce health to a calorie counter or a single workout program.

The application should combine:

-   weight management
-   fat-loss planning
-   muscle gain/bulking
-   body recomposition
-   strength
-   hypertrophy
-   cardiovascular fitness
-   mobility
-   flexibility
-   balance
-   coordination
-   calisthenics
-   martial arts and combat-sport conditioning
-   self-defence education
-   walking and everyday movement
-   dance
-   yoga
-   Pilates
-   Tai Chi
-   Qigong
-   traditional African movement and diets
-   traditional and complementary approaches
-   lymphatic health and lymphatic drainage information
-   nutrition
-   fasting/time-restricted eating
-   supplements
-   sleep
-   stress management
-   cortisol education
-   recovery
-   behavior change
-   digital tracking
-   wearable integration
-   evidence-based research
-   long-term weight maintenance

The central principle is:

> **Give users evidence-informed options, explain what is known and
> unknown, personalize safely, and let the user choose.**

The application must distinguish: 1. evidence-supported interventions;
2. promising but uncertain interventions; 3. traditional/cultural
practices; 4. consumer wellness practices; 5. claims that lack
sufficient evidence; 6. clinically established treatments that require
professional supervision.

------------------------------------------------------------------------

# 2. Core Product Philosophy

## 2.1 Do not build a "weight-loss-only" app

Weight is one measurement, not the entire objective.

The application should track and optimize multiple outcomes:

-   body weight
-   waist circumference
-   body-fat percentage when reliable measurement is available
-   lean mass where reliable measurement is available
-   strength
-   endurance
-   resting heart rate
-   activity
-   sleep
-   recovery
-   mobility
-   fitness performance
-   nutrition
-   stress
-   adherence
-   subjective wellbeing

A user can become healthier and fitter without large changes on the
scale.

A user can also lose weight without improving body composition or
fitness.

The application should therefore show these outcomes separately.

------------------------------------------------------------------------

# 3. Primary User Goals

Users should be able to select one or more goals.

## 3.1 Weight reduction

Examples:

-   lose body weight
-   reduce waist circumference
-   reduce body fat
-   improve metabolic health
-   improve fitness while losing weight

## 3.2 Fat loss

Focus on:

-   reducing fat mass
-   preserving lean mass
-   maintaining or increasing strength
-   improving waist/visceral-fat-related outcomes

## 3.3 Muscle gain / bulking

Focus on:

-   increasing lean mass
-   increasing strength
-   progressive resistance training
-   sufficient protein
-   appropriate energy intake
-   recovery

## 3.4 Body recomposition

Goal:

-   reduce fat
-   preserve or increase muscle

Especially relevant for:

-   beginners
-   people returning to training
-   people with higher body-fat levels
-   people who prefer slower changes

## 3.5 Strength

Goals may include:

-   general strength
-   relative strength
-   maximal strength
-   calisthenics strength
-   grip strength
-   core strength
-   explosive strength

## 3.6 Endurance

-   walking
-   running
-   cycling
-   swimming
-   rowing
-   hiking
-   combat conditioning

## 3.7 Mobility and flexibility

-   range of motion
-   joint mobility
-   flexibility
-   movement quality

## 3.8 Combat fitness

-   boxing fitness
-   kickboxing fitness
-   Muay Thai conditioning
-   grappling conditioning
-   MMA conditioning
-   agility
-   reaction
-   coordination
-   power

## 3.9 Self-defence education

Focus on:

-   awareness
-   avoidance
-   de-escalation
-   escape
-   physical conditioning
-   defensive movement
-   safe training
-   scenario awareness

The application must not encourage unnecessary violence or provide
instructions intended to facilitate serious injury.

## 3.10 Stress and recovery

-   stress management
-   sleep
-   recovery
-   relaxation
-   mindfulness
-   breathing
-   cortisol education

## 3.11 Lymphatic health

-   lymphatic-system education
-   lymphedema education
-   movement
-   exercise
-   manual lymphatic drainage information
-   compression therapy education
-   when to seek clinical care

This must not be marketed as a generic "detox" system.

------------------------------------------------------------------------

# 4. User Profile

The onboarding flow should collect only information necessary for
personalization.

## 4.1 Basic information

-   age
-   sex where relevant to physiological calculations
-   height
-   current weight
-   optional target weight
-   activity level
-   training experience

## 4.2 Body measurements

Optional:

-   waist
-   hips
-   neck
-   chest
-   arms
-   thighs
-   body-fat estimate
-   lean mass estimate

Measurements must be labeled with their method and reliability.

## 4.3 Training background

-   beginner
-   intermediate
-   advanced
-   returning after a break

Preferred activities:

-   gym
-   home
-   outdoors
-   combat sports
-   calisthenics
-   running
-   walking
-   cycling
-   swimming
-   dance
-   yoga
-   Pilates
-   traditional practices

## 4.4 Equipment

-   no equipment
-   resistance bands
-   dumbbells
-   kettlebells
-   barbell
-   rack
-   machines
-   pull-up bar
-   dip bars
-   treadmill
-   bike
-   rowing machine
-   swimming pool
-   combat equipment

## 4.5 Lifestyle

Optional:

-   occupation activity
-   commuting
-   average steps
-   sleep duration
-   meal schedule
-   dietary pattern
-   budget
-   food availability
-   cultural food preferences

------------------------------------------------------------------------

# 5. Safety Screening

Before generating exercise or nutrition plans, the application should
identify situations requiring professional assessment.

Potential flags include:

-   chest pain
-   unexplained fainting
-   severe shortness of breath
-   serious cardiovascular disease
-   uncontrolled hypertension
-   pregnancy
-   recent surgery
-   significant injury
-   eating-disorder history or active eating disorder
-   severe underweight
-   unexplained rapid weight loss
-   severe edema
-   suspected lymphedema
-   known kidney disease
-   known liver disease
-   diabetes requiring medical management
-   medications affecting weight, glucose, blood pressure or exercise
    tolerance
-   other conditions where exercise/nutrition changes may require
    clinical supervision

The app should not diagnose.

It should say when professional evaluation may be appropriate.

------------------------------------------------------------------------

# 6. Evidence Architecture

Every intervention in the database should have structured evidence
metadata.

## 6.1 Evidence fields

Each intervention should store:

-   intervention name
-   category
-   subcategory
-   target outcome
-   population studied
-   study type
-   number of studies
-   participant count
-   intervention duration
-   comparator
-   effect estimate where available
-   confidence interval where available
-   statistical significance
-   clinical significance
-   certainty of evidence
-   adverse effects
-   contraindications
-   practical requirements
-   cost
-   equipment
-   accessibility
-   cultural context
-   source
-   publication year
-   PubMed ID
-   DOI
-   systematic-review status
-   last evidence review date

## 6.2 Evidence hierarchy

Preferred evidence order:

1.  systematic reviews and meta-analyses
2.  umbrella reviews
3.  randomized controlled trials
4.  controlled trials
5.  prospective cohort studies
6.  observational studies
7.  mechanistic studies
8.  expert consensus
9.  traditional use
10. anecdotal reports

Traditional use must not be represented as equivalent to clinical
evidence.

------------------------------------------------------------------------

# 7. Weight Management Research

## 7.1 Energy balance

Research and education should cover:

-   energy intake
-   energy expenditure
-   basal metabolic rate
-   total daily energy expenditure
-   thermic effect of food
-   physical activity
-   non-exercise activity thermogenesis
-   adaptive responses
-   appetite compensation
-   dietary adherence

## 7.2 Weight-loss rate

The app should avoid universally prescribing one rate for every person.

It should explain that appropriate rates depend on:

-   starting body composition
-   health status
-   goal
-   training status
-   energy intake
-   protein intake
-   lean mass
-   duration
-   individual response

## 7.3 Weight-loss measurements

Track:

-   daily weight where desired
-   weekly average
-   rolling 7-day average
-   monthly trend
-   waist
-   body-fat estimate
-   photos if the user chooses
-   strength
-   performance

Avoid interpreting a single scale reading as fat gain or fat loss.

------------------------------------------------------------------------

# 8. Fat Loss

The app should distinguish:

-   body weight reduction
-   fat mass reduction
-   visceral fat reduction
-   abdominal subcutaneous fat
-   lean mass preservation
-   water fluctuations
-   glycogen changes
-   gastrointestinal contents

Education should explain that scale weight can change from:

-   water
-   sodium
-   carbohydrates/glycogen
-   menstrual cycle
-   bowel contents
-   inflammation
-   training
-   hydration

Therefore, trend data is more useful than isolated measurements.

------------------------------------------------------------------------

# 9. Dietary Approaches

The app should support multiple dietary patterns without declaring one
universally superior.

## 9.1 Calorie-controlled diets

-   calorie deficit
-   calorie maintenance
-   calorie surplus

## 9.2 High-protein diets

Track:

-   total protein
-   protein per meal
-   protein sources
-   distribution

## 9.3 Mediterranean-style diets

Research:

-   weight
-   cardiovascular outcomes
-   metabolic health
-   adherence

## 9.4 Low-fat diets

## 9.5 Low-carbohydrate diets

## 9.6 Higher-carbohydrate performance diets

Relevant to:

-   endurance
-   combat sports
-   high-volume training

## 9.7 Plant-based diets

-   vegetarian
-   vegan
-   flexitarian

## 9.8 Traditional African diets

Research:

-   cereals
-   legumes
-   seeds
-   nuts
-   traditional vegetables
-   indigenous fruits
-   fermented foods
-   traditional cooking
-   regional dietary patterns

Include Kenyan/East African foods where possible.

Examples to research:

-   ugali
-   millet
-   sorghum
-   beans
-   ndengu
-   githeri
-   sukuma wiki
-   traditional leafy vegetables
-   arrowroot
-   sweet potato
-   cassava
-   bananas
-   maize
-   indigenous fruits
-   fermented foods

Do not assume traditional foods are automatically healthier; evaluate
dietary pattern, preparation, portions and evidence.

## 9.9 Intermittent fasting

Support research on:

-   12:12
-   14:10
-   16:8
-   18:6
-   20:4
-   OMAD
-   5:2
-   alternate-day fasting
-   prolonged fasting
-   time-restricted eating
-   early time-restricted eating
-   late time-restricted eating
-   religious fasting
-   Ramadan fasting

Compare fasting with conventional calorie restriction.

------------------------------------------------------------------------

# 10. Appetite and Eating Behavior

Track:

-   hunger
-   fullness
-   cravings
-   emotional eating
-   stress eating
-   boredom eating
-   night eating
-   meal timing
-   eating speed
-   protein intake
-   fiber intake
-   sleep
-   stress

Behavioral tools:

-   food diary
-   hunger scale
-   mindful eating
-   meal planning
-   portion awareness
-   environmental restructuring
-   shopping lists
-   meal preparation
-   reminders
-   accountability

------------------------------------------------------------------------

# 11. Non-Exercise Activity Thermogenesis

NEAT must be a first-class feature.

Track:

-   steps
-   walking
-   standing
-   household chores
-   gardening
-   cleaning
-   occupational movement
-   commuting
-   stairs
-   movement breaks

Users should be able to set practical movement goals without requiring
formal workouts.

------------------------------------------------------------------------

# 12. Exercise Database

Every exercise should have structured metadata.

## Fields

-   exercise name
-   category
-   primary muscles
-   secondary muscles
-   movement pattern
-   equipment
-   skill level
-   difficulty
-   estimated intensity
-   aerobic demand
-   strength demand
-   power demand
-   mobility demand
-   balance demand
-   coordination demand
-   injury considerations
-   progression
-   regression
-   sets
-   reps
-   duration
-   rest
-   tempo
-   coaching cues
-   common mistakes
-   alternatives

------------------------------------------------------------------------

# 13. Aerobic Exercise

Include:

### Walking

-   casual walking
-   brisk walking
-   power walking
-   uphill walking
-   treadmill walking
-   walking intervals
-   hiking
-   Nordic walking
-   weighted walking

### Running

-   jogging
-   steady-state running
-   long-distance running
-   tempo running
-   intervals
-   hills
-   treadmill running
-   sprinting

### Cycling

-   outdoor cycling
-   indoor cycling
-   spin
-   intervals
-   commuting

### Swimming

-   lap swimming
-   recreational swimming
-   swimming intervals
-   water aerobics

### Rowing

-   rowing machine
-   outdoor rowing
-   rowing intervals

### Stairs

-   stair climbing
-   stair intervals
-   step machines
-   stadium stairs

### Other

-   elliptical
-   cross-trainer
-   aerobic classes

------------------------------------------------------------------------

# 14. HIIT and Sprint Training

Include:

-   HIIT
-   sprint interval training
-   repeated sprint training
-   circuit HIIT
-   running HIIT
-   cycling HIIT
-   rowing HIIT
-   bodyweight HIIT
-   combat-specific intervals

Store:

-   work duration
-   recovery duration
-   number of intervals
-   intensity
-   total session time

Do not prescribe maximal intensity to beginners without appropriate
progression.

------------------------------------------------------------------------

# 15. Resistance Training

Include:

-   barbells
-   dumbbells
-   kettlebells
-   machines
-   cables
-   resistance bands
-   bodyweight
-   weighted calisthenics
-   isometrics
-   eccentric training
-   unilateral training
-   circuits

Training variables:

-   load
-   repetitions
-   sets
-   weekly volume
-   frequency
-   intensity
-   proximity to failure
-   tempo
-   rest
-   range of motion
-   exercise selection
-   progression

------------------------------------------------------------------------

# 16. Hypertrophy

Research:

-   mechanical tension
-   volume
-   intensity
-   frequency
-   progressive overload
-   exercise selection
-   range of motion
-   proximity to failure
-   protein
-   energy intake
-   sleep
-   recovery

The app should avoid treating one exact rep range as mandatory for
hypertrophy.

------------------------------------------------------------------------

# 17. Strength

Track:

-   1RM where appropriate
-   estimated 1RM
-   repetitions at load
-   relative strength
-   movement-specific strength
-   grip strength
-   isometric strength

Avoid requiring maximal lifts from inexperienced users.

------------------------------------------------------------------------

# 18. Calisthenics

Dedicated library:

### Beginner

-   wall push-ups
-   incline push-ups
-   push-ups
-   bodyweight squats
-   lunges
-   glute bridges
-   planks
-   dead bugs

### Intermediate

-   pull-ups
-   chin-ups
-   dips
-   decline push-ups
-   Bulgarian split squats
-   hanging knee raises
-   pike push-ups

### Advanced

-   muscle-ups
-   handstand
-   handstand push-up
-   L-sit
-   front lever
-   back lever
-   planche
-   human flag
-   pistol squat

Track progress through:

-   reps
-   holds
-   leverage
-   range of motion
-   assistance level
-   added weight

------------------------------------------------------------------------

# 19. Plyometrics and Power

Include:

-   jumps
-   hops
-   bounds
-   box jumps
-   broad jumps
-   medicine-ball throws
-   explosive push-ups
-   jump squats
-   Olympic-lifting derivatives

Track:

-   jump height
-   distance
-   repetitions
-   landing quality
-   rest

------------------------------------------------------------------------

# 20. Mobility and Flexibility

Include:

-   dynamic mobility
-   static stretching
-   active flexibility
-   passive flexibility
-   joint-specific mobility
-   warm-ups
-   cooldowns
-   movement preparation

Track:

-   range of motion
-   discomfort
-   consistency
-   progress

------------------------------------------------------------------------

# 21. Balance, Coordination and Agility

Include:

-   single-leg balance
-   reaction drills
-   ladder drills
-   cone drills
-   lateral movement
-   change of direction
-   footwork
-   coordination games
-   proprioception

------------------------------------------------------------------------

# 22. Dance

Include:

-   African dance
-   traditional dance
-   Afrobeat dance
-   Zumba
-   salsa
-   ballroom
-   hip-hop
-   aerobic dance
-   cultural/community dance

Track:

-   duration
-   intensity
-   estimated energy expenditure
-   enjoyment
-   adherence

------------------------------------------------------------------------

# 23. Yoga

Include:

-   Hatha
-   Vinyasa
-   Ashtanga
-   Power yoga
-   hot yoga
-   restorative yoga
-   Iyengar
-   Kundalini

Research outcomes:

-   weight
-   body composition
-   flexibility
-   strength
-   balance
-   stress
-   sleep
-   mindfulness

Do not present yoga as a guaranteed fat-loss method.

------------------------------------------------------------------------

# 24. Pilates

Include:

-   mat Pilates
-   reformer Pilates
-   resistance Pilates
-   core-focused Pilates

Research:

-   body composition
-   core strength
-   flexibility
-   posture
-   balance
-   functional fitness

------------------------------------------------------------------------

# 25. Tai Chi, Qigong and Traditional Movement

Include:

-   Tai Chi
-   Qigong
-   Baduanjin
-   traditional movement sequences
-   breathing + movement

Research:

-   balance
-   stress
-   sleep
-   cardiovascular health
-   metabolic health
-   mobility
-   older-adult fitness

------------------------------------------------------------------------

# 26. Combat Sports

Dedicated combat library.

## Striking

-   boxing
-   kickboxing
-   Muay Thai
-   karate
-   taekwondo
-   kung fu
-   wushu
-   sanda
-   savate
-   capoeira

## Grappling

-   Brazilian Jiu-Jitsu
-   judo
-   wrestling
-   sambo
-   submission grappling
-   catch wrestling

## Mixed

-   MMA
-   combat sambo
-   other mixed systems

## Traditional / weapons-oriented cultural practices

For historical/cultural/fitness research:

-   kendo
-   Eskrima/Arnis/Kali
-   silat
-   HEMA
-   traditional African combat systems
-   traditional wrestling systems

------------------------------------------------------------------------

# 27. Combat Conditioning

Track:

-   aerobic capacity
-   anaerobic capacity
-   repeated sprint ability
-   rounds
-   work/rest ratio
-   footwork
-   reaction
-   coordination
-   power
-   grip
-   trunk strength
-   neck strength
-   mobility

Combat-specific conditioning can include:

-   shadowboxing
-   heavy-bag intervals
-   pad work
-   technical drills
-   grappling rounds
-   wrestling drills
-   circuit conditioning

Sparring should be treated separately because of contact and injury
risk.

------------------------------------------------------------------------

# 28. Self-Defence

Self-defence education should emphasize:

1.  awareness
2.  prevention
3.  avoidance
4.  boundary setting
5.  verbal de-escalation
6.  escape
7.  seeking help
8.  emergency response
9.  safe physical training

Fitness components:

-   sprinting
-   agility
-   balance
-   reaction
-   strength
-   grip
-   getting up from the ground
-   controlled falling
-   movement under stress

The application should not teach users to seek confrontation or provide
harmful instructions.

------------------------------------------------------------------------

# 29. Combat-Sport Weight Management

Create a separate educational section on:

-   normal body composition management
-   gradual weight reduction
-   competition weight categories
-   weight cutting
-   dehydration
-   glycogen manipulation
-   rapid weight loss
-   recovery after weigh-in

Clearly distinguish healthy body-composition management from rapid
competition weight cutting.

Potential harms of rapid weight cutting must be clearly explained.

------------------------------------------------------------------------

# 30. Lymphatic System and Lymphatic Health

Use accurate terminology:

**Lymphatic health / lymph flow / lymphatic drainage / lymphedema
management**

Avoid generic claims that "lymphatic detox" removes toxins or burns fat.

## Topics

-   lymphatic anatomy
-   lymph movement
-   skeletal muscle pump
-   respiration
-   edema
-   lymphedema
-   breast-cancer-related lymphedema
-   chronic lymphedema
-   exercise
-   compression
-   manual lymphatic drainage
-   complete decongestive therapy
-   pneumatic compression

------------------------------------------------------------------------

# 31. Manual Lymphatic Drainage

Explain:

-   what MLD is
-   who uses it
-   clinical indications
-   evidence
-   limitations
-   trained-provider requirement
-   when not to perform it

The app should not encourage self-treatment of unexplained swelling.

Red flags for urgent medical assessment can include:

-   sudden unilateral swelling
-   significant pain
-   redness/warmth
-   sudden shortness of breath
-   chest pain
-   unexplained severe edema

------------------------------------------------------------------------

# 32. Lymphatic-Friendly Movement

Research and educate around:

-   walking
-   ankle pumps
-   calf raises
-   gentle mobility
-   aerobic activity
-   progressive resistance
-   breathing
-   swimming

Where clinical lymphedema is involved, users should be directed toward
qualified healthcare professionals.

------------------------------------------------------------------------

# 33. Traditional African Approaches

Create a dedicated knowledge library for:

-   traditional African diets
-   traditional physical activity
-   traditional dance
-   indigenous games
-   traditional wrestling
-   community movement
-   agricultural activity
-   herbal medicine
-   fasting traditions
-   culturally adapted interventions

Country filters:

-   Kenya
-   Uganda
-   Tanzania
-   Rwanda
-   Ethiopia
-   Ghana
-   Nigeria
-   South Africa
-   Zambia
-   Zimbabwe
-   other African countries

Do not assume evidence from one African population automatically applies
to another.

------------------------------------------------------------------------

# 34. African Traditional Medicine

Track research on:

-   Irvingia gabonensis
-   Cissus quadrangularis
-   Moringa
-   Garcinia species
-   Hoodia
-   Nigella sativa
-   fenugreek
-   bitter melon
-   hibiscus
-   ginger
-   cinnamon
-   green tea
-   Caralluma
-   Phaseolus vulgaris
-   traditional vegetables
-   indigenous fruits
-   other documented traditional medicines

Every herb must have:

-   plant name
-   local names
-   preparation
-   studied dose
-   studied population
-   outcome
-   evidence
-   adverse effects
-   drug interactions
-   pregnancy considerations
-   liver/kidney considerations
-   quality-control concerns

Do not present supplements as automatically safe because they are
natural.

------------------------------------------------------------------------

# 35. Traditional Chinese Medicine

Include:

-   acupuncture
-   electroacupuncture
-   auricular acupuncture
-   acupressure
-   ear seeds
-   moxibustion
-   cupping
-   massage
-   traditional herbal formulations

Evidence must be separated from traditional-use claims.

------------------------------------------------------------------------

# 36. Indian / Ayurvedic Practices

Include research categories for:

-   Ayurveda
-   yoga
-   traditional dietary practices
-   herbal preparations
-   meditation
-   breathing practices
-   massage

Herbal preparations require safety and interaction review.

------------------------------------------------------------------------

# 37. Other Traditional / Indigenous Practices

Research:

-   Indigenous diets
-   traditional games
-   pastoralist activity
-   hunter-gatherer movement
-   community dance
-   cultural sports
-   traditional healing
-   traditional fasting

The database should preserve cultural context instead of stripping
practices from their origin.

------------------------------------------------------------------------

# 38. Supplements

Categories:

## High-evidence fitness supplements to investigate

-   creatine
-   protein supplements
-   caffeine
-   beta-alanine
-   carbohydrate/electrolyte products where performance-relevant

## Other supplements

-   omega-3
-   vitamin D
-   magnesium
-   iron where clinically indicated
-   fiber
-   probiotics
-   other supplements

## Weight-loss supplements

Research individually rather than accepting marketing claims.

For every supplement:

-   evidence
-   dose studied
-   population
-   outcome
-   effect size
-   adverse effects
-   interactions
-   regulatory status
-   contamination risk
-   quality-control concerns

------------------------------------------------------------------------

# 39. Creatine

Track:

-   creatine monohydrate
-   dosage
-   loading vs no-loading protocols
-   strength
-   lean mass
-   body mass
-   fat mass
-   hydration
-   novice vs experienced lifters

Do not portray creatine-related water-weight increases as fat gain.

------------------------------------------------------------------------

# 40. Protein

Track:

-   total daily protein
-   protein per meal
-   animal sources
-   plant sources
-   whey
-   casein
-   soy
-   other protein supplements

Research:

-   muscle hypertrophy
-   strength
-   satiety
-   weight loss
-   muscle preservation during calorie restriction

------------------------------------------------------------------------

# 41. Sleep

Track:

-   duration
-   consistency
-   bedtime
-   wake time
-   sleep quality
-   awakenings
-   sleep debt
-   naps

Research:

-   sleep and appetite
-   sleep and weight
-   sleep and insulin sensitivity
-   sleep and recovery
-   sleep and cortisol
-   sleep and muscle growth

------------------------------------------------------------------------

# 42. Stress and Cortisol

The application must teach that cortisol is a normal hormone and should
not be treated as something users need to eliminate.

Research:

-   HPA axis
-   circadian cortisol rhythm
-   acute stress
-   chronic stress
-   exercise
-   sleep
-   psychological stress
-   mindfulness
-   meditation
-   relaxation
-   breathing
-   nutrition
-   overtraining

Distinguish:

-   measured cortisol
-   perceived stress
-   wearable "stress" estimates

A wearable stress score is not the same thing as a laboratory cortisol
measurement.

------------------------------------------------------------------------

# 43. Stress-Management Interventions

Include:

-   mindfulness
-   meditation
-   MBSR
-   breathing exercises
-   progressive muscle relaxation
-   yoga
-   Tai Chi
-   Qigong
-   CBT-informed techniques
-   relaxation
-   nature exposure
-   social connection
-   journaling
-   sleep improvement

Track:

-   perceived stress
-   sleep
-   mood
-   recovery
-   adherence

Do not diagnose mental-health conditions.

------------------------------------------------------------------------

# 44. Wearables

Integrations should be designed around available APIs and permissions.

Potential ecosystems:

-   Apple Health
-   Fitbit
-   Garmin
-   Samsung Health
-   Google Health Connect
-   Polar
-   Oura
-   WHOOP
-   other supported wearable platforms

Possible data:

-   steps
-   heart rate
-   resting heart rate
-   workouts
-   calories
-   sleep
-   HRV where available
-   respiratory rate where available
-   weight
-   body composition where supported

The app must clearly label imported data and device-estimated metrics.

------------------------------------------------------------------------

# 45. Fitness Apps to Study / Potential Integrations

## Nutrition

-   MyFitnessPal
-   Cronometer
-   Lose It!
-   MacroFactor
-   MyNetDiary
-   FatSecret
-   Lifesum
-   YAZIO
-   Carb Manager
-   MyPlate

## Strength

-   Strong
-   Hevy
-   Fitbod
-   JEFIT
-   Boostcamp
-   Alpha Progression
-   StrongLifts
-   JuggernautAI

## Running

-   Strava
-   Nike Run Club
-   Runna
-   Adidas Running
-   MapMyRun

## General fitness

-   Nike Training Club
-   FitOn
-   Freeletics
-   Centr
-   Apple Fitness+
-   Peloton
-   Les Mills+
-   Sweat

## Walking

-   Apple Health
-   Google Fit / Health Connect ecosystem
-   Fitbit
-   Pacer
-   Samsung Health

## Yoga / mobility

-   Down Dog
-   Yoga with Adriene
-   Glo
-   Alo Moves
-   Daily Yoga

## Meditation / stress

-   Headspace
-   Calm
-   Insight Timer
-   Balance
-   Waking Up
-   Breath-focused applications

## Sleep

-   Oura
-   WHOOP
-   Sleep Cycle
-   Pillow
-   AutoSleep

The app should treat these as ecosystems/tools to integrate with where
technically and legally possible, not as evidence that each product is
clinically effective.

------------------------------------------------------------------------

# 46. Digital Behavior-Change Features

Research-supported feature categories include:

-   self-monitoring
-   goal setting
-   feedback
-   reminders
-   progress tracking
-   coaching
-   action planning
-   personalized recommendations
-   social support
-   accountability
-   rewards
-   habit tracking

The system should avoid excessive notifications that could encourage
compulsive tracking.

------------------------------------------------------------------------

# 47. Core App Modules

## Module 1 --- Dashboard

Show:

-   current goal
-   weight trend
-   waist trend
-   activity
-   workouts
-   protein
-   calories if tracking
-   sleep
-   recovery
-   stress
-   weekly progress
-   adherence

## Module 2 --- Body

-   weight
-   measurements
-   body composition
-   progress photos
-   trend charts

## Module 3 --- Nutrition

-   food diary
-   calories
-   macros
-   protein
-   fiber
-   meals
-   recipes
-   meal plans
-   fasting
-   traditional foods

## Module 4 --- Training

-   workout builder
-   exercise library
-   plans
-   progressive overload
-   sets/reps/load
-   cardio
-   calisthenics
-   combat conditioning
-   mobility

## Module 5 --- Combat

-   boxing
-   kickboxing
-   Muay Thai
-   MMA conditioning
-   grappling conditioning
-   reaction
-   footwork
-   agility
-   self-defence education

## Module 6 --- Recovery

-   sleep
-   stress
-   recovery
-   HRV where available
-   resting HR
-   relaxation

## Module 7 --- Lymphatic Health

-   education
-   movement
-   clinical information
-   MLD education
-   symptom tracking
-   provider guidance

## Module 8 --- Research Library

Search and filter:

-   topic
-   intervention
-   year
-   study design
-   population
-   outcome
-   evidence certainty

## Module 9 --- Traditional Practices

-   African
-   Asian
-   Ayurvedic
-   Indigenous
-   herbal
-   traditional exercise
-   traditional diets

## Module 10 --- Apps & Wearables

-   integrations
-   imported data
-   supported devices
-   data permissions

------------------------------------------------------------------------

# 48. Personalized Recommendation Engine

The engine should not simply say:

"Do this."

Instead:

1.  identify the user's goal;
2.  assess constraints;
3.  identify feasible interventions;
4.  rank options by evidence relevance and user preference;
5.  explain tradeoffs;
6.  provide alternatives;
7.  allow user choice;
8.  monitor outcomes;
9.  adjust based on observed response.

Example:

If a user wants fat loss and hates running, the system should not force
running.

It can offer:

-   walking
-   cycling
-   swimming
-   dance
-   boxing fitness
-   resistance training
-   HIIT
-   hiking
-   calisthenics

based on preference and safety.

------------------------------------------------------------------------

# 49. Program Generator

The program generator should create:

## Fat-loss program

-   resistance training
-   aerobic activity
-   steps
-   nutrition target
-   protein target
-   sleep target
-   recovery
-   weekly review

## Muscle-building program

-   resistance training
-   volume
-   progression
-   protein
-   energy target
-   sleep
-   recovery

## Recomposition program

-   resistance training
-   adequate protein
-   moderate calorie strategy
-   cardio
-   measurements
-   strength tracking

## Calisthenics program

-   skill progression
-   strength
-   mobility
-   core
-   pulling
-   pushing
-   legs

## Combat-fitness program

-   conditioning
-   strength
-   mobility
-   footwork
-   reaction
-   technique practice
-   recovery

## General health program

-   walking
-   resistance
-   aerobic fitness
-   mobility
-   sleep
-   stress management

------------------------------------------------------------------------

# 50. Exercise Recommendation Algorithm

For every workout, consider:

-   user goal
-   fitness level
-   available equipment
-   available time
-   injuries/limitations
-   preference
-   previous workload
-   recovery
-   progression
-   weekly volume

Output:

-   warm-up
-   main exercises
-   sets
-   repetitions
-   intensity
-   rest
-   cooldown
-   optional alternative exercises

------------------------------------------------------------------------

# 51. Adaptive Progression

The application should use actual performance.

If the user completes:

-   target reps comfortably
-   target sets
-   acceptable technique
-   appropriate recovery

then progression can be considered.

Progression options:

-   increase load
-   increase repetitions
-   increase sets
-   increase range of motion
-   increase exercise difficulty
-   reduce assistance
-   increase duration
-   increase pace

If recovery is poor:

-   reduce volume
-   reduce intensity
-   increase rest
-   use a recovery session

------------------------------------------------------------------------

# 52. Weight-Loss Adaptation

The app should not react to one day's weight.

Use:

-   rolling averages
-   multiple measurements
-   waist
-   adherence
-   activity
-   nutrition
-   training
-   menstrual-cycle context where voluntarily provided
-   sleep
-   stress

If progress stalls for a meaningful period, review:

1.  actual intake
2.  activity
3.  tracking accuracy
4.  adherence
5.  water fluctuations
6.  sleep
7.  training
8.  medical factors where relevant

------------------------------------------------------------------------

# 53. Muscle-Gain Adaptation

Track:

-   body weight trend
-   strength
-   reps
-   volume
-   measurements
-   body-fat trend if available
-   protein
-   calories
-   recovery

Do not automatically increase calories every time weight fails to
increase for a few days.

Use longer trends.

------------------------------------------------------------------------

# 54. Recovery Engine

Inputs:

-   sleep
-   resting HR
-   HRV if available
-   soreness
-   fatigue
-   stress
-   previous workload
-   subjective recovery

Outputs:

-   train normally
-   reduce intensity
-   reduce volume
-   mobility
-   walking
-   recovery day
-   sleep recommendation

The app should avoid pretending that wearable recovery scores are
medical diagnoses.

------------------------------------------------------------------------

# 55. Lymphatic Safety Engine

If the user reports:

-   unexplained swelling
-   one-sided swelling
-   sudden edema
-   pain
-   redness
-   warmth
-   shortness of breath
-   chest pain

the app should stop generic lymphatic recommendations and direct the
user toward medical assessment as appropriate.

------------------------------------------------------------------------

# 56. Nutrition Database

Store:

-   food
-   serving
-   calories
-   protein
-   carbohydrates
-   fat
-   fiber
-   sodium
-   micronutrients
-   cuisine
-   country
-   preparation method

Include:

-   Kenyan foods
-   East African foods
-   African foods
-   international foods

Allow users to submit foods for review rather than silently accepting
inaccurate nutrition data.

------------------------------------------------------------------------

# 57. Traditional Food Database

For each food:

-   local name
-   English name
-   region
-   ingredients
-   traditional preparation
-   nutrition
-   serving size
-   evidence
-   modern preparation alternatives

Examples:

-   ugali
-   githeri
-   beans
-   ndengu
-   sukuma wiki
-   kunde
-   managu
-   terere
-   millet
-   sorghum
-   cassava
-   sweet potato
-   arrowroot
-   plantain
-   traditional fermented foods

------------------------------------------------------------------------

# 58. Recipe Engine

Recipes should support:

-   calorie target
-   protein target
-   dietary pattern
-   budget
-   ingredients available
-   culture/cuisine
-   cooking time
-   equipment
-   allergies
-   preferences

Allow:

-   Kenyan meals
-   African meals
-   Mediterranean meals
-   Asian meals
-   vegetarian meals
-   vegan meals
-   high-protein meals

------------------------------------------------------------------------

# 59. Fasting Module

Features:

-   fasting timer
-   schedule
-   hydration reminders
-   meal window
-   fasting history
-   adherence

Educational warnings:

-   fasting is not appropriate for everyone
-   certain medical conditions and medications require professional
    guidance
-   prolonged fasting should not be casually recommended

------------------------------------------------------------------------

# 60. Habit System

Habits:

-   steps
-   water
-   protein
-   vegetables
-   sleep
-   workouts
-   mobility
-   meditation
-   meal preparation
-   fasting if appropriate
-   recovery

Allow users to choose habits rather than assigning too many.

------------------------------------------------------------------------

# 61. Progress Dashboard

Charts:

-   weight trend
-   waist trend
-   body-fat trend
-   lean mass trend
-   strength trend
-   step trend
-   workout frequency
-   sleep trend
-   protein adherence
-   calorie trend
-   resting HR
-   HRV where available
-   perceived stress
-   recovery

------------------------------------------------------------------------

# 62. Research Library

Each paper should have:

``` text
Title
Authors
Year
Journal
DOI
PubMed ID
Study design
Population
Sample size
Intervention
Comparator
Duration
Primary outcome
Secondary outcomes
Effect size
Confidence interval
Limitations
Evidence certainty
Practical interpretation
Tags
```

Search filters:

-   weight loss
-   fat loss
-   muscle gain
-   hypertrophy
-   protein
-   creatine
-   cardio
-   resistance
-   calisthenics
-   combat
-   martial arts
-   self-defence
-   dance
-   yoga
-   Pilates
-   Tai Chi
-   Qigong
-   traditional African
-   herbal
-   acupuncture
-   lymphatic
-   cortisol
-   sleep
-   stress
-   apps
-   wearables

------------------------------------------------------------------------

# 63. Evidence Labels

Use transparent labels rather than numerical "health scores."

Suggested labels:

-   Strong evidence
-   Moderate evidence
-   Limited evidence
-   Mixed evidence
-   Preliminary evidence
-   Traditional use / insufficient clinical evidence
-   Evidence against the claim
-   Unknown

Every label should be generated from explicit evidence rules.

------------------------------------------------------------------------

# 64. Avoid Health Misinformation

The system must flag claims such as:

-   "detoxes the body"
-   "melts belly fat"
-   "flushes cortisol"
-   "drains fat through the lymph"
-   "boosts metabolism 10x"
-   "guaranteed weight loss"
-   "no calorie deficit required"
-   "one exercise burns belly fat specifically"
-   "sweating equals fat loss"
-   "supplements are always safe because they are natural"

Instead, explain the underlying physiology and evidence.

------------------------------------------------------------------------

# 65. No Spot-Reduction Claims

The app should not promise that:

-   ab exercises burn belly fat specifically
-   arm exercises selectively remove arm fat
-   thigh exercises selectively remove thigh fat

It can explain:

-   local muscle development
-   overall fat loss
-   changes in body composition

------------------------------------------------------------------------

# 66. No "Cortisol Belly" Simplification

The app should avoid diagnosing a user's abdominal fat as
cortisol-driven.

Explain that abdominal/visceral adiposity is influenced by multiple
factors including:

-   energy balance
-   genetics
-   age
-   sex
-   sleep
-   stress
-   activity
-   diet
-   metabolic health
-   hormonal physiology

Cortisol should be discussed as one physiological factor, not a
universal explanation.

------------------------------------------------------------------------

# 67. No "Lymphatic Detox" Claims

Use:

-   lymphatic health
-   lymph flow
-   edema
-   lymphedema
-   drainage
-   clinical management

Avoid implying that ordinary massage removes body fat or "toxins."

------------------------------------------------------------------------

# 68. Social Features

Optional:

-   challenges
-   groups
-   accountability
-   workout sharing
-   progress sharing
-   community
-   local walking groups
-   dance groups
-   combat-sport communities

Privacy must be strong.

Users should control what is shared.

------------------------------------------------------------------------

# 69. Gamification

Possible:

-   streaks
-   milestones
-   badges
-   personal records
-   workout consistency
-   walking milestones
-   strength milestones
-   calisthenics skill milestones

Avoid rewarding unhealthy behaviors such as:

-   extreme calorie restriction
-   excessive exercise
-   rapid weight loss
-   dangerous weight cutting
-   prolonged fasting

------------------------------------------------------------------------

# 70. App Architecture

Suggested layers:

``` text
Mobile/Web UI
     |
API / Application Layer
     |
------------------------------------------------
| User Profile | Plans | Tracking | Research  |
------------------------------------------------
     |
Recommendation Engine
     |
Evidence / Knowledge Layer
     |
------------------------------------------------
| Exercise DB | Food DB | Research DB | Herbs |
------------------------------------------------
     |
Integrations
------------------------------------------------
| Apple Health | Health Connect | Fitbit      |
| Garmin       | Oura          | WHOOP       |
------------------------------------------------
```

------------------------------------------------------------------------

# 71. Core Database Entities

Suggested entities:

-   User
-   UserGoal
-   HealthProfile
-   BodyMeasurement
-   WeightEntry
-   NutritionEntry
-   Food
-   Recipe
-   Meal
-   Exercise
-   ExerciseSession
-   Workout
-   WorkoutSet
-   Program
-   ProgramWeek
-   TrainingPlan
-   CombatDiscipline
-   CombatSession
-   CalisthenicsSkill
-   MobilityExercise
-   SleepEntry
-   StressEntry
-   RecoveryEntry
-   WearableData
-   Supplement
-   TraditionalPractice
-   Herb
-   LymphaticIntervention
-   ResearchPaper
-   EvidenceReview
-   EvidenceTag
-   Habit
-   HabitLog
-   ProgressMetric
-   SafetyFlag
-   Notification
-   UserPreference

------------------------------------------------------------------------

# 72. Example Exercise Schema

``` json
{
  "name": "Push-up",
  "category": "calisthenics",
  "movement_pattern": "horizontal_push",
  "level": "beginner",
  "equipment": "none",
  "primary_muscles": ["chest", "triceps", "anterior_deltoid"],
  "secondary_muscles": ["core"],
  "goals": ["strength", "hypertrophy", "general_fitness"],
  "progressions": [
    "incline_push_up",
    "standard_push_up",
    "decline_push_up",
    "weighted_push_up"
  ],
  "regressions": [
    "wall_push_up",
    "knee_push_up"
  ],
  "tracking": ["sets", "reps", "tempo"]
}
```

------------------------------------------------------------------------

# 73. Research Source Strategy

Primary research sources should include:

-   PubMed
-   PubMed Central
-   Cochrane Library
-   major medical journals
-   sports-science journals
-   nutrition journals
-   exercise physiology journals
-   public-health journals
-   clinical guidelines
-   government health agencies
-   professional medical organizations

Use reputable sources for:

-   dietary guidelines
-   exercise guidelines
-   lymphedema management
-   supplement safety
-   medication interactions

------------------------------------------------------------------------

# 74. Initial Research Seed Library

The following papers should seed the database.

## Weight loss / exercise

### Exercise training and weight loss

"Effect of exercise training on weight loss, body composition changes,
and weight maintenance in adults with overweight or obesity: an overview
of 12 systematic reviews and 149 studies."

PubMed: https://pubmed.ncbi.nlm.nih.gov/33955140/

### Aerobic exercise and weight loss

"Aerobic Exercise and Weight Loss in Adults: A Systematic Review and
Dose-Response Meta-Analysis."

PubMed: https://pubmed.ncbi.nlm.nih.gov/39724371/

### Resistance training and weight loss

"Resistance training effectiveness on body composition and body weight
outcomes in individuals with overweight and obesity across the
lifespan."

PubMed: https://pubmed.ncbi.nlm.nih.gov/35191588/

### Resistance exercise during dietary weight loss

"Effect of resistance exercise on body composition, muscle strength and
cardiometabolic health during dietary weight loss."

PubMed: https://pubmed.ncbi.nlm.nih.gov/40909191/

------------------------------------------------------------------------

# 75. Diet and fasting research

### Intermittent fasting

"Intermittent fasting for weight management and metabolic health: An
updated comprehensive umbrella review of health outcomes."

PubMed: https://pubmed.ncbi.nlm.nih.gov/39618023/

### Dietary patterns

"Comparison of weight loss effects among overweight/obese adults: A
network meta-analysis of Mediterranean, low-carbohydrate, and low-fat
diets."

PubMed: https://pubmed.ncbi.nlm.nih.gov/39255914/

------------------------------------------------------------------------

# 76. Protein and hypertrophy research

### Protein supplementation

"A systematic review, meta-analysis and meta-regression of the effect of
protein supplementation on resistance-training-induced gains in muscle
mass and strength."

PubMed: https://pubmed.ncbi.nlm.nih.gov/28698222/

### Protein timing/types

"Effects of Timing and Types of Protein Supplementation on Improving
Muscle Mass, Strength, and Physical Performance in Adults Undergoing
Resistance Training."

PubMed: https://pubmed.ncbi.nlm.nih.gov/38039960/

------------------------------------------------------------------------

# 77. Resistance-training research

### Training load

"Influence of resistance training load on measures of skeletal muscle
hypertrophy and improvements in maximal strength."

PubMed: https://pubmed.ncbi.nlm.nih.gov/33874848/

### Training frequency

"How many times per week should a muscle be trained to maximize muscle
hypertrophy?"

PubMed: https://pubmed.ncbi.nlm.nih.gov/30558493/

### Resistance-training dose response

"The Resistance Training Dose Response: Meta-Regressions Exploring the
Effects of Weekly Volume and Frequency on Muscle Hypertrophy and
Strength Gains."

PubMed: https://pubmed.ncbi.nlm.nih.gov/41343037/

### Energy surplus

"Is an Energy Surplus Required to Maximize Skeletal Muscle Hypertrophy
Associated With Resistance Training?"

PubMed: https://pubmed.ncbi.nlm.nih.gov/31482093/

------------------------------------------------------------------------

# 78. Creatine research

### Creatine and body composition

"The Effect of Creatine Supplementation on Resistance Training-Based
Changes to Body Composition."

PubMed: https://pubmed.ncbi.nlm.nih.gov/39074168/

### Creatine and resistance training

"Creatine supplementation and resistance training: a comparison between
novice and experienced lifters."

PubMed: https://pubmed.ncbi.nlm.nih.gov/41433021/

### Newer creatine analysis

"Resistance training combined with creatine supplementation: a
three-level meta-analysis of multidimensional outcomes."

PubMed: https://pubmed.ncbi.nlm.nih.gov/42765482/

------------------------------------------------------------------------

# 79. Sleep research

### Sleep and obesity

"Sleep duration and obesity in adulthood: An updated systematic review
and meta-analysis."

PubMed: https://pubmed.ncbi.nlm.nih.gov/32527625/

### Sleep extension

"Effect of Sleep Extension on Objectively Assessed Energy Intake Among
Adults With Overweight in Real-life Settings."

PubMed: https://pubmed.ncbi.nlm.nih.gov/35129580/

### Sleep deprivation and cortisol

"The effect of acute sleep deprivation on cortisol level."

PubMed: https://pubmed.ncbi.nlm.nih.gov/38777757/

------------------------------------------------------------------------

# 80. Cortisol and stress research

### Exercise, cortisol and sleep

"The effects of physical activity on cortisol and sleep: A systematic
review and meta-analysis."

PubMed: https://pubmed.ncbi.nlm.nih.gov/35777076/

### Stress management and cortisol

"Effectiveness of stress management interventions to change cortisol
levels: a systematic review and meta-analysis."

PubMed: https://pubmed.ncbi.nlm.nih.gov/37879237/

### Mindfulness and cortisol

"Mindfulness-based stress reduction interventions and cortisol
regulation: A systematic review and meta-analysis."

PubMed: https://pubmed.ncbi.nlm.nih.gov/42691284/

------------------------------------------------------------------------

# 81. Dance research

### Dance and obesity

Systematic review/meta-analysis examining dance interventions and body
composition in people with overweight/obesity.

PubMed: https://pubmed.ncbi.nlm.nih.gov/38232096/

### African dance

Pilot randomized study examining African dance and weight-related
outcomes in older African Americans.

PubMed: https://pubmed.ncbi.nlm.nih.gov/30358132/

------------------------------------------------------------------------

# 82. Martial arts research

### Martial arts and health

Systematic review examining martial arts including kung fu, Tai Chi,
judo, karate and taekwondo.

PubMed: https://pubmed.ncbi.nlm.nih.gov/21349072/

### Hard martial arts

Systematic review examining physiological, physical and psychological
effects of hard martial arts.

PubMed: https://pubmed.ncbi.nlm.nih.gov/29157151/

### Combat sports

Systematic review of combat sports including boxing, BJJ, judo, karate,
kickboxing, Muay Thai, wrestling and MMA.

PubMed: https://pubmed.ncbi.nlm.nih.gov/26993133/

### Strength training in combat sports

Systematic review of strength-training effects in Olympic combat sports.

PubMed: https://pubmed.ncbi.nlm.nih.gov/36834211/

### HIIT in combat athletes

Systematic review/meta-analysis of HIIT, sprint interval and
repeated-sprint training in combat sports.

PubMed: https://pubmed.ncbi.nlm.nih.gov/31904713/

------------------------------------------------------------------------

# 83. Combat-sport weight management

2026 systematic review examining body composition and dietary intake in
combat-sport athletes.

PubMed: https://pubmed.ncbi.nlm.nih.gov/41901059/

Use this evidence to distinguish gradual body-composition management
from rapid competition weight cutting.

------------------------------------------------------------------------

# 84. Lymphatic research

### Manual lymphatic drainage

Systematic review of manual lymphatic drainage for lymphedema.

PubMed: https://pubmed.ncbi.nlm.nih.gov/32803533/

### Exercise and lymphedema

Research examining resistance and aerobic exercise in
lymphedema/breast-cancer-related lymphedema.

PubMed: https://pubmed.ncbi.nlm.nih.gov/22002586/

The app should maintain a clear distinction between:

-   lymphedema treatment
-   edema management
-   normal lymphatic physiology
-   wellness massage
-   fat loss

------------------------------------------------------------------------

# 85. African Traditional Medicine Research

### African traditional medicine and metabolic syndrome

2026 systematic review examining African traditional medicines,
including plant species studied for metabolic outcomes.

PubMed: https://pubmed.ncbi.nlm.nih.gov/41520564/

### African traditional diets

Recent scoping research examining traditional African dietary patterns.

PubMed: https://pubmed.ncbi.nlm.nih.gov/41019548/

### Herbal weight management

Systematic review of herbal medicines for appetite suppression.

PubMed: https://pubmed.ncbi.nlm.nih.gov/31126562/

### Herbal medicines and weight

Systematic review/meta-analysis of randomized placebo-controlled trials
of herbal agents for weight loss.

PubMed: https://pubmed.ncbi.nlm.nih.gov/31984610/

### Irvingia gabonensis

Systematic review of African bush mango and weight management.

PubMed: https://pubmed.ncbi.nlm.nih.gov/23419021/

------------------------------------------------------------------------

# 86. Traditional Chinese Medicine

### Acupuncture

2026 systematic review/meta-analysis of acupuncture for obesity/weight
outcomes.

PubMed: https://pubmed.ncbi.nlm.nih.gov/40737234/

### Acupuncture modalities

Network meta-analysis including manual acupuncture, electroacupuncture,
auricular acupuncture and acupressure.

PubMed: https://pubmed.ncbi.nlm.nih.gov/39234040/

### Traditional Chinese medicine

Network meta-analysis examining traditional Chinese medicine
interventions for weight management.

PubMed: https://pubmed.ncbi.nlm.nih.gov/38863737/

------------------------------------------------------------------------

# 87. Mobile Health / Apps Research

### Digital interventions

2025 umbrella review of mobile and web-based interventions for
overweight/obesity.

PubMed: https://pubmed.ncbi.nlm.nih.gov/40724217/

### Mobile apps

2024 meta-analysis of mobile-app interventions for
obesity/weight-related outcomes.

PubMed: https://pubmed.ncbi.nlm.nih.gov/39049288/

### Commercial weight-management apps

Systematic review examining behavioral features of commercial
weight-management apps.

PubMed: https://pubmed.ncbi.nlm.nih.gov/27460502/

### Behavioral features in apps

Meta-analysis examining digital interventions and behavioral techniques
including reminders, self-reporting and coaching.

PubMed: https://pubmed.ncbi.nlm.nih.gov/36379104/

### Digital self-monitoring

Research examining digital self-monitoring of diet and physical
activity.

PubMed: https://pubmed.ncbi.nlm.nih.gov/34192411/

------------------------------------------------------------------------

# 88. Sub-Saharan Africa

Include dedicated evidence searches for:

-   Kenya
-   Uganda
-   Tanzania
-   Rwanda
-   Ethiopia
-   Ghana
-   Nigeria
-   South Africa
-   Zambia
-   Zimbabwe
-   other sub-Saharan African populations

### Regional obesity interventions

2025 systematic review/meta-analysis examining obesity interventions in
sub-Saharan Africa, including aerobic exercise, resistance exercise,
micronutrient supplementation and physical education.

PubMed: https://pubmed.ncbi.nlm.nih.gov/40408622/

------------------------------------------------------------------------

# 89. Research Search Strategy

The research engine should continuously search combinations such as:

## Weight

-   weight loss systematic review
-   obesity exercise meta-analysis
-   fat loss randomized trial
-   weight maintenance systematic review
-   body composition meta-analysis

## Exercise

-   resistance training hypertrophy meta-analysis
-   aerobic exercise weight loss
-   HIIT obesity
-   walking weight loss
-   running body composition
-   swimming weight loss
-   cycling body composition
-   dance obesity
-   calisthenics strength
-   bodyweight training hypertrophy

## Combat

-   boxing exercise health
-   boxing body composition
-   martial arts fitness
-   MMA conditioning
-   Muay Thai physiology
-   BJJ fitness
-   judo strength
-   wrestling conditioning
-   combat sports body composition
-   martial arts weight management

## Self-defence

-   self-defence training physical fitness
-   self-defence awareness intervention
-   women's self-defence training
-   de-escalation training
-   defensive skills physical fitness

## Lymphatic

-   lymphatic drainage systematic review
-   manual lymphatic drainage
-   exercise lymphedema
-   resistance training lymphedema
-   walking lymphatic flow
-   lymphatic rehabilitation

## Cortisol

-   exercise cortisol meta-analysis
-   sleep cortisol
-   stress management cortisol
-   mindfulness cortisol
-   yoga cortisol
-   meditation cortisol
-   resistance training cortisol
-   HIIT cortisol

## Traditional

-   African traditional medicine obesity
-   African traditional diet obesity
-   Kenyan traditional diet health
-   East African diet metabolic health
-   African dance exercise
-   traditional wrestling fitness
-   acupuncture obesity
-   Ayurveda weight management
-   traditional Chinese medicine obesity

------------------------------------------------------------------------

# 90. Evidence Review Workflow

For every newly discovered paper:

1.  Identify study design.
2.  Identify population.
3.  Record sample size.
4.  Record intervention.
5.  Record comparator.
6.  Record duration.
7.  Record primary outcomes.
8.  Record effect size.
9.  Record uncertainty.
10. Record adverse events.
11. Record limitations.
12. Determine whether evidence is applicable to the user's population.
13. Tag intervention.
14. Link to related research.
15. Update evidence summary.

------------------------------------------------------------------------

# 91. Personalization Engine

Recommendations should be based on:

-   goal
-   age
-   sex where relevant
-   body size
-   training experience
-   fitness
-   equipment
-   time
-   preferences
-   dietary culture
-   budget
-   sleep
-   recovery
-   previous performance
-   adherence
-   safety flags

The system should prioritize feasibility and adherence rather than
prescribing an theoretically ideal but impractical program.

------------------------------------------------------------------------

# 92. User Choice

For every major goal, show multiple pathways.

Example:

## Goal: Fat loss

Possible paths:

### Path A --- Gym

Resistance + cardio + nutrition

### Path B --- Home

Calisthenics + walking + nutrition

### Path C --- Combat

Boxing/Muay Thai fitness + resistance + nutrition

### Path D --- Outdoor

Walking/hiking + bodyweight training

### Path E --- Dance

Dance + resistance + walking

### Path F --- Mixed

User-selected combination

This makes the application adaptive rather than prescriptive.

------------------------------------------------------------------------

# 93. Accessibility

Support:

-   beginners
-   older adults
-   people with limited mobility
-   people without gym access
-   low-income users
-   users in rural areas
-   users with limited equipment
-   users with limited time

Provide:

-   no-equipment workouts
-   10-minute workouts
-   20-minute workouts
-   30-minute workouts
-   full-length workouts
-   home alternatives
-   outdoor alternatives

------------------------------------------------------------------------

# 94. Cultural Localization

Kenya/East Africa should be a first-class localization target.

Include:

-   Kenyan foods
-   local food prices where available
-   local measurement units
-   local exercise preferences
-   local gyms
-   local walking environments
-   local dance
-   local martial arts
-   traditional practices
-   local languages where practical

Do not imply that Western fitness models are the only valid approaches.

------------------------------------------------------------------------

# 95. Cost-Aware Planning

Users should be able to select:

-   free
-   low cost
-   moderate cost
-   gym membership
-   premium

Examples:

### Free

-   walking
-   calisthenics
-   running
-   outdoor stairs
-   mobility
-   bodyweight circuits

### Low cost

-   resistance bands
-   jump rope
-   basic dumbbells

### Gym

-   machines
-   barbells
-   cable systems

### Specialized

-   swimming
-   martial arts
-   combat gym
-   Pilates reformer

------------------------------------------------------------------------

# 96. Time-Aware Planning

Offer:

-   5-minute mobility
-   10-minute movement
-   15-minute workout
-   20-minute workout
-   30-minute workout
-   45-minute workout
-   60-minute workout
-   longer sessions

The application should optimize around available time.

------------------------------------------------------------------------

# 97. Beginner Mode

Beginner programs should emphasize:

-   technique
-   consistency
-   gradual progression
-   manageable volume
-   recovery
-   safety

Do not begin with advanced:

-   HIIT
-   heavy lifting
-   advanced calisthenics
-   hard sparring
-   extreme fasting
-   rapid weight loss

------------------------------------------------------------------------

# 98. Advanced Mode

Allow:

-   structured periodization
-   advanced hypertrophy
-   strength programming
-   advanced calisthenics
-   combat conditioning
-   performance metrics
-   advanced nutrition tracking

Still maintain safety constraints.

------------------------------------------------------------------------

# 99. Periodization

Support:

-   linear progression
-   undulating progression
-   block periodization
-   hypertrophy blocks
-   strength blocks
-   power blocks
-   deloads
-   conditioning blocks
-   skill blocks

------------------------------------------------------------------------

# 100. Workout Types

Database should include:

-   strength
-   hypertrophy
-   fat-loss circuit
-   aerobic base
-   HIIT
-   sprint
-   mobility
-   recovery
-   calisthenics
-   boxing conditioning
-   combat conditioning
-   dance
-   yoga
-   Pilates
-   walking
-   hiking
-   swimming
-   cycling
-   mixed sessions

------------------------------------------------------------------------

# 101. User Feedback

After workouts ask concise questions:

-   difficulty
-   soreness
-   energy
-   pain
-   enjoyment
-   perceived exertion

Use feedback to adjust future sessions.

Pain should not simply be treated as normal training difficulty.

------------------------------------------------------------------------

# 102. RPE / RIR

Support:

-   RPE
-   reps in reserve
-   talk test for cardio
-   heart-rate zones where appropriate

Users can train based on effort rather than exact loads when necessary.

------------------------------------------------------------------------

# 103. Exercise Alternatives

Every exercise should have substitutions.

Example:

Squat alternatives:

-   goblet squat
-   bodyweight squat
-   leg press
-   split squat
-   step-up
-   box squat

Running alternatives:

-   walking
-   cycling
-   swimming
-   rowing
-   elliptical

Pull-up alternatives:

-   assisted pull-up
-   lat pulldown
-   band pulldown
-   inverted row

------------------------------------------------------------------------

# 104. Research-Based Recommendation Explanations

Whenever the system recommends something, it should optionally answer:

**Why?**

Example:

> Resistance training is included because research during dietary weight
> loss indicates that it can help preserve fat-free mass while improving
> strength.

Then show:

-   evidence level
-   relevant studies
-   population
-   limitations

This is preferable to opaque AI recommendations.

------------------------------------------------------------------------

# 105. AI Assistant

The app may include an AI coach that can:

-   explain research
-   build workouts
-   adjust workouts
-   answer nutrition questions
-   summarize research
-   explain exercises
-   interpret trends
-   suggest alternatives
-   create meal ideas
-   explain traditional practices

But AI must not:

-   diagnose
-   claim certainty where evidence is weak
-   invent research
-   fabricate nutrition data
-   diagnose hormone problems
-   diagnose lymphedema
-   diagnose eating disorders
-   replace medical care

------------------------------------------------------------------------

# 106. Research Chat

Users should be able to ask:

-   "What does research say about walking for weight loss?"
-   "Does boxing build muscle?"
-   "Is HIIT better than walking?"
-   "Does fasting work?"
-   "What does the evidence say about cortisol?"
-   "Does lymphatic drainage reduce fat?"
-   "Can calisthenics build muscle?"
-   "What are the benefits of African dance?"
-   "Does creatine cause fat gain?"
-   "Can I gain muscle while losing fat?"

The system should answer with sources.

------------------------------------------------------------------------

# 107. Research Comparison Tool

Allow users to compare:

-   walking vs running
-   HIIT vs steady-state cardio
-   resistance vs cardio
-   calisthenics vs weights
-   boxing vs running
-   swimming vs cycling
-   yoga vs Pilates
-   fasting vs calorie restriction
-   Mediterranean vs low-carb
-   traditional vs modern dietary patterns
-   MLD vs compression where clinically appropriate

Do not automatically label one intervention "best."

Show:

-   outcome
-   evidence
-   magnitude
-   limitations
-   practical requirements
-   risks
-   cost
-   adherence considerations

------------------------------------------------------------------------

# 108. Research Evidence Matrix

Example:

  -------------------------------------------------------------------------------------------------------------
  Intervention   Weight        Fat           Muscle         Fitness   Stress      Sleep       Evidence
  -------------- ------------- ------------- -------------- --------- ----------- ----------- -----------------
  Walking        ✓             ✓             Low            ✓         Possible    Possible    Moderate

  Resistance     ✓             ✓             ✓✓✓            ✓✓        Variable    Variable    Strong

  HIIT           ✓             ✓             Low/Moderate   ✓✓✓       Variable    Variable    Moderate

  Calisthenics   ✓             ✓             ✓✓             ✓✓        Variable    Variable    Moderate/varied

  Boxing fitness ✓             ✓             ✓              ✓✓✓       Potential   Potential   Varied

  Dance          ✓             ✓             Low/Moderate   ✓✓        Potential   Potential   Moderate

  Yoga           Variable      Variable      Low/Moderate   ✓         ✓✓          ✓           Moderate/varied

  MLD            Not           Not           ---            ---       Variable    Variable    Clinical context
                 established   established                                                    
                 as fat loss                                                                  

  Fasting        ✓             ✓             Variable       ---       Variable    Variable    Moderate

  Creatine       ---           ---/small     ✓✓✓            ✓✓✓       ---         ---         Strong for
                               effects                                                        performance
  -------------------------------------------------------------------------------------------------------------

This table should remain dynamic and evidence-linked rather than
hardcoded as a universal verdict.

------------------------------------------------------------------------

# 109. Data Privacy

Health and fitness information is sensitive.

The app should implement:

-   encryption
-   access control
-   secure authentication
-   minimal data collection
-   export
-   deletion
-   consent
-   integration permission management
-   audit logs
-   secure backups

Do not sell health data without explicit lawful consent and appropriate
safeguards.

------------------------------------------------------------------------

# 110. Data Ownership

Users should be able to:

-   export data
-   delete data
-   disconnect wearables
-   revoke permissions
-   delete individual measurements
-   delete account

------------------------------------------------------------------------

# 111. Notification System

Notifications may include:

-   workout reminder
-   meal logging reminder
-   hydration reminder
-   sleep reminder
-   research update
-   progress review
-   recovery reminder

Avoid:

-   shame
-   guilt
-   excessive reminders
-   fear-based messaging
-   weight-loss pressure

------------------------------------------------------------------------

# 112. Long-Term Weight Maintenance

The application must continue after the user reaches a target.

Track:

-   maintenance weight
-   activity
-   nutrition
-   strength
-   sleep
-   habits
-   relapse risk
-   environmental changes

The goal should be sustainable behavior rather than permanent dieting.

------------------------------------------------------------------------

# 113. Special Population Research

The research database should have separate tags for:

-   children/adolescents
-   young adults
-   adults
-   older adults
-   pregnant people
-   postpartum populations
-   athletes
-   combat athletes
-   people with obesity
-   people with overweight
-   people with normal body weight
-   people with chronic conditions

Evidence should never automatically be generalized across populations.

------------------------------------------------------------------------

# 114. Research Quality Controls

For every paper:

-   verify publication
-   verify PubMed record where available
-   identify retractions
-   identify corrections
-   record conflicts of interest
-   distinguish industry-funded research
-   distinguish preprints from peer-reviewed papers
-   record publication date
-   record population
-   avoid extrapolation

------------------------------------------------------------------------

# 115. Claim Verification

The app should maintain a "claim database."

Example:

**Claim:** "Sweating burns fat."

Status:

-   sweating causes fluid loss;
-   sweat loss is not equivalent to fat loss;
-   weight may temporarily decrease through fluid loss.

**Claim:** "Lymphatic massage melts fat."

Status:

-   no established evidence that massage melts adipose tissue;
-   MLD has clinical applications in edema/lymphedema;
-   do not market MLD as a fat-loss treatment.

**Claim:** "Cortisol causes belly fat."

Status:

-   oversimplification;
-   stress physiology may interact with appetite, behavior and metabolic
    processes;
-   abdominal adiposity is multifactorial.

------------------------------------------------------------------------

# 116. Analytics

Track product metrics:

-   active users
-   workout adherence
-   plan completion
-   retention
-   nutrition logging
-   sleep logging
-   research engagement
-   goal completion
-   feature usage

Do not optimize solely for time spent in the app.

A healthy product can encourage users to spend less time in the app once
habits become established.

------------------------------------------------------------------------

# 117. Gamification Safety Metrics

Monitor for:

-   excessive exercise
-   rapid weight loss
-   extreme calorie restriction
-   compulsive weighing
-   repeated fasting
-   overtraining
-   dangerous weight cutting

Introduce friction or professional-support guidance where appropriate.

------------------------------------------------------------------------

# 118. Accessibility and Inclusion

Support:

-   different body sizes
-   different fitness levels
-   different cultures
-   different dietary traditions
-   different budgets
-   different abilities
-   different equipment access

Avoid assuming:

-   everyone wants to be thin
-   everyone wants to bulk
-   everyone wants a gym
-   everyone wants calorie tracking

------------------------------------------------------------------------

# 119. Minimum Viable Product

MVP should include:

1.  onboarding
2.  goals
3.  weight/measurement tracking
4.  exercise library
5.  workout builder
6.  calisthenics
7.  cardio
8.  resistance training
9.  basic nutrition
10. protein tracking
11. sleep
12. stress
13. research library
14. evidence labels
15. progress dashboard

------------------------------------------------------------------------

# 120. Phase 2

Add:

-   combat sports
-   self-defence education
-   dance
-   yoga
-   Pilates
-   Tai Chi
-   Qigong
-   traditional African practices
-   fasting
-   supplements
-   recipes
-   wearable integrations

------------------------------------------------------------------------

# 121. Phase 3

Add:

-   lymphatic health module
-   clinical referral pathways
-   advanced research database
-   personalized AI coaching
-   adaptive programming
-   advanced analytics
-   research comparison engine
-   multilingual support

------------------------------------------------------------------------

# 122. Phase 4

Add:

-   community
-   local fitness providers
-   coaches
-   researchers
-   verified practitioners
-   local food database
-   regional exercise programs
-   culturally adapted programs

------------------------------------------------------------------------

# 123. Final Product Definition

The finished application should effectively function as:

**Fitness tracker + workout planner + nutrition tracker +
body-composition tracker + research library + evidence-based coach +
traditional-practice encyclopedia + combat-fitness system +
recovery/stress platform + lymphatic-health education system.**

It should not be merely a calorie counter.

------------------------------------------------------------------------

# 124. Guiding Principle

The product should continuously answer five questions:

### 1. What is the user's goal?

Weight loss, fat loss, muscle gain, fitness, strength, combat
performance, health, stress reduction, recovery, or another goal.

### 2. What does the evidence say?

Show research and uncertainty.

### 3. What is practical for this person?

Consider time, equipment, culture, budget and preference.

### 4. What is safe?

Screen for risks and refer when appropriate.

### 5. Is it working?

Measure outcomes and adapt.

------------------------------------------------------------------------

# 125. Core Research Philosophy

The app should never assume:

-   modern = better
-   traditional = better
-   expensive = better
-   natural = safe
-   harder = better
-   more exercise = better
-   lower calories = better
-   lower weight = better
-   higher protein = unlimited benefit
-   higher cortisol = always bad
-   sweating = fat loss
-   lymph drainage = fat loss
-   fasting = automatically superior
-   supplements = necessary
-   gym training = required
-   running = required
-   one diet = universally best

Instead:

> **Measure the intervention, measure the outcome, evaluate the
> evidence, account for the person, and adapt.**

------------------------------------------------------------------------

# 126. Development Backlog

## Foundation

-   [ ] User authentication
-   [ ] User profile
-   [ ] Goals
-   [ ] Safety screening
-   [ ] Preferences
-   [ ] Units

## Body tracking

-   [ ] Weight
-   [ ] Waist
-   [ ] Measurements
-   [ ] Photos
-   [ ] Body composition

## Exercise

-   [ ] Exercise database
-   [ ] Workout builder
-   [ ] Program generator
-   [ ] Progressive overload
-   [ ] Cardio
-   [ ] Resistance
-   [ ] Calisthenics
-   [ ] Mobility
-   [ ] Dance
-   [ ] Yoga
-   [ ] Pilates
-   [ ] Tai Chi
-   [ ] Qigong
-   [ ] Combat
-   [ ] Self-defence education

## Nutrition

-   [ ] Food database
-   [ ] Kenyan/African foods
-   [ ] Recipes
-   [ ] Calories
-   [ ] Macros
-   [ ] Protein
-   [ ] Fiber
-   [ ] Fasting

## Recovery

-   [ ] Sleep
-   [ ] Stress
-   [ ] Recovery
-   [ ] HRV
-   [ ] Resting HR
-   [ ] Mindfulness
-   [ ] Breathing

## Lymphatic

-   [ ] Lymphatic education
-   [ ] MLD education
-   [ ] Exercise
-   [ ] Symptom tracking
-   [ ] Referral warnings

## Research

-   [ ] Paper database
-   [ ] PubMed ingestion
-   [ ] Evidence classification
-   [ ] Search
-   [ ] Filters
-   [ ] Research summaries
-   [ ] Comparisons
-   [ ] Citation management

## Traditional

-   [ ] African practices
-   [ ] African foods
-   [ ] African herbs
-   [ ] TCM
-   [ ] Ayurveda
-   [ ] Indigenous practices

## Integrations

-   [ ] Apple Health
-   [ ] Health Connect
-   [ ] Fitbit
-   [ ] Garmin
-   [ ] Oura
-   [ ] WHOOP
-   [ ] Strava
-   [ ] Other supported APIs

## AI

-   [ ] AI coach
-   [ ] Research assistant
-   [ ] Plan generator
-   [ ] Adaptive recommendations
-   [ ] Research citations
-   [ ] Safety guardrails

------------------------------------------------------------------------

# 127. Success Criteria

The application succeeds when a user can enter:

-   who they are
-   what they want
-   what they can realistically do
-   what they enjoy
-   what equipment they have
-   what foods they eat
-   how they sleep
-   how stressed they are
-   how active they are

and receive:

1.  a safe starting plan;
2.  multiple evidence-informed options;
3.  explanations for why those options were selected;
4.  progress tracking;
5.  adaptive recommendations;
6.  access to the underlying research;
7.  traditional/cultural alternatives;
8.  combat/calisthenics alternatives;
9.  recovery and stress support;
10. clear warnings where professional medical care is appropriate.

------------------------------------------------------------------------

# 128. End State

The long-term product should become a **personal fitness and health
knowledge platform**, not simply another workout application.

It should connect:

**Research → Evidence → User Goal → Personal Context → Exercise →
Nutrition → Recovery → Behavior → Measurement → Adaptation.**

The application should make it possible for a user to choose among
conventional, modern, traditional, cultural and recreational approaches
while clearly showing the difference between:

**what is proven, what is promising, what is traditional, what is
uncertain, and what is unsupported.**

That distinction is the foundation of the product.
