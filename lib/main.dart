import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:like_button/like_button.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:async';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const FitnessApp());
}

class FitnessApp extends StatelessWidget {
  const FitnessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FitFusion',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        fontFamily: 'Poppins',
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: AnimatedTextKit(
          animatedTexts: [
            TyperAnimatedText(
              'FitFusion',
              textStyle: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
              speed: const Duration(milliseconds: 100),
            ),
          ],
          isRepeatingAnimation: false,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.deepPurple),
            onPressed: () {
              showSearch(
                context: context,
                delegate: ExerciseSearchDelegate(),
              );
            },
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: const [
          WorkoutCategoriesScreen(),
          FavoritesScreen(),
          WorkoutPlansScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Plans',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ).animate().fadeIn(duration: 500.ms),
    );
  }
}

class WorkoutCategoriesScreen extends StatelessWidget {
  const WorkoutCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Popular Workouts',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: popularWorkouts.length,
              itemBuilder: (context, index) {
                return WorkoutCard(workout: popularWorkouts[index]);
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Workout Categories',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: workoutCategories.length,
            padding: const EdgeInsets.all(10),
            itemBuilder: (context, index) {
              return CategoryCard(category: workoutCategories[index]);
            },
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Quick Workouts',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ...quickWorkouts.map((workout) => QuickWorkoutTile(workout: workout)).toList(),
        ],
      ),
    );
  }
}

class WorkoutCard extends StatefulWidget {
  final Workout workout;

  const WorkoutCard({super.key, required this.workout});

  @override
  State<WorkoutCard> createState() => _WorkoutCardState();
}

class _WorkoutCardState extends State<WorkoutCard> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WorkoutDetailScreen(workout: widget.workout),
          ),
        );
      },
      child: Container(
        width: 160,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
              child: Stack(
                children: [
                  Image.asset(
                    widget.workout.imageUrl,
                    width: double.infinity,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: LikeButton(
                      size: 30,
                      isLiked: isFavorite,
                      onTap: (isLiked) async {
                        setState(() {
                          isFavorite = !isFavorite;
                        });
                        return !isLiked;
                      },
                      likeBuilder: (bool isLiked) {
                        return Icon(
                          isLiked ? Icons.favorite : Icons.favorite_border,
                          color: isLiked ? Colors.red : Colors.white,
                          size: 30,
                        );
                      },
                      circleColor: const CircleColor(
                        start: Colors.red,
                        end: Colors.pinkAccent,
                      ),
                      bubblesColor: const BubblesColor(
                        dotPrimaryColor: Colors.red,
                        dotSecondaryColor: Colors.pinkAccent,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.workout.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${widget.workout.duration} min',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ).animate().scale(delay: 100.ms).then().shake(),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final WorkoutCategory category;

  const CategoryCard({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryDetailScreen(category: category),
          ),
        );
      },
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                category.color.withOpacity(0.8),
                category.color.withOpacity(0.4),
              ],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  category.icon,
                  size: 40,
                  color: Colors.white,
                ),
                const SizedBox(height: 10),
                Text(
                  category.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ).animate().fadeIn().slide(),
    );
  }
}

class QuickWorkoutTile extends StatelessWidget {
  final Workout workout;

  const QuickWorkoutTile({super.key, required this.workout});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(
            workout.imageUrl,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          workout.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          '${workout.duration} min • ${workout.difficulty}',
          style: TextStyle(
            color: Colors.grey[600],
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.play_circle_fill, color: Colors.deepPurple),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WorkoutTimerScreen(workout: workout),
              ),
            );
          },
        ),
      ),
    ).animate().fadeIn().slideX();
  }
}

class WorkoutDetailScreen extends StatefulWidget {
  final Workout workout;

  const WorkoutDetailScreen({super.key, required this.workout});

  @override
  State<WorkoutDetailScreen> createState() => _WorkoutDetailScreenState();
}

class _WorkoutDetailScreenState extends State<WorkoutDetailScreen> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.workout.videoUrl)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite ? Colors.red : Colors.white,
            ),
            onPressed: () {
              setState(() {
                _isFavorite = !_isFavorite;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: _controller.value.isInitialized
                      ? VideoPlayer(_controller)
                      : Image.asset(
                    widget.workout.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned.fill(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isPlaying = !_isPlaying;
                        if (_isPlaying) {
                          _controller.play();
                        } else {
                          _controller.pause();
                        }
                      });
                    },
                    child: Container(
                      color: Colors.transparent,
                      child: Center(
                        child: Icon(
                          _isPlaying ? Icons.pause : Icons.play_arrow,
                          size: 50,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ),
                  ),
                ),
                VideoProgressIndicator(
                  _controller,
                  allowScrubbing: true,
                  colors: const VideoProgressColors(
                    playedColor: Colors.deepPurple,
                    bufferedColor: Colors.grey,
                    backgroundColor: Colors.white24,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.workout.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.timer, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        '${widget.workout.duration} min',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      const SizedBox(width: 16),
                      Icon(Icons.fitness_center, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        widget.workout.difficulty,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      const SizedBox(width: 16),
                      Icon(Icons.star, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        '${widget.workout.calories} cal',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.workout.description,
                    style: TextStyle(color: Colors.grey[700], height: 1.5),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Exercises',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...widget.workout.exercises.map((exercise) => ExerciseStepItem(
                    exercise: exercise,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExerciseDetailScreen(
                            exercise: exercise,
                          ),
                        ),
                      );
                    },
                  )),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                WorkoutTimerScreen(workout: widget.workout),
                          ),
                        );
                      },
                      child: const Text(
                        'Start Workout',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ExerciseStepItem extends StatelessWidget {
  final Exercise exercise;
  final VoidCallback onTap;

  const ExerciseStepItem({
    super.key,
    required this.exercise,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                exercise.imageUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exercise.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${exercise.duration} sec • ${exercise.repetitions} reps',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

class ExerciseDetailScreen extends StatelessWidget {
  final Exercise exercise;

  const ExerciseDetailScreen({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(exercise.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              exercise.imageUrl,
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${exercise.duration} seconds',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${exercise.repetitions} reps',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Instructions',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...exercise.instructions.map((instruction) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('• '),
                        Expanded(
                          child: Text(
                            instruction,
                            style: TextStyle(
                              fontSize: 16,
                              height: 1.5,
                              color: Colors.grey[800],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
                  const SizedBox(height: 16),
                  if (exercise.tips.isNotEmpty) ...[
                    const Text(
                      'Tips',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...exercise.tips.map((tip) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('• '),
                          Expanded(
                            child: Text(
                              tip,
                              style: TextStyle(
                                fontSize: 16,
                                height: 1.5,
                                color: Colors.grey[800],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WorkoutTimerScreen extends StatefulWidget {
  final Workout workout;

  const WorkoutTimerScreen({super.key, required this.workout});

  @override
  State<WorkoutTimerScreen> createState() => _WorkoutTimerScreenState();
}

class _WorkoutTimerScreenState extends State<WorkoutTimerScreen> {
  int _currentExerciseIndex = 0;
  int _secondsRemaining = 0;
  bool _isRunning = false;
  late Timer _timer;
  bool _isWorkoutComplete = false;

  @override
  void initState() {
    super.initState();
    _secondsRemaining = widget.workout.exercises[_currentExerciseIndex].duration;
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    setState(() {
      _isRunning = true;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _nextExercise();
        }
      });
    });
  }

  void _pauseTimer() {
    setState(() {
      _isRunning = false;
    });
    _timer.cancel();
  }

  void _nextExercise() {
    _timer.cancel();
    setState(() {
      if (_currentExerciseIndex < widget.workout.exercises.length - 1) {
        _currentExerciseIndex++;
        _secondsRemaining = widget.workout.exercises[_currentExerciseIndex].duration;
        _isRunning = false;
      } else {
        _isWorkoutComplete = true;
      }
    });
  }

  void _previousExercise() {
    _timer.cancel();
    setState(() {
      if (_currentExerciseIndex > 0) {
        _currentExerciseIndex--;
        _secondsRemaining = widget.workout.exercises[_currentExerciseIndex].duration;
        _isRunning = false;
      }
    });
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    if (_isWorkoutComplete) {
      return WorkoutCompleteScreen(workout: widget.workout);
    }

    final currentExercise = widget.workout.exercises[_currentExerciseIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Timer'),
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: (_currentExerciseIndex + 1) / widget.workout.exercises.length,
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.deepPurple),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Exercise ${_currentExerciseIndex + 1} of ${widget.workout.exercises.length}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.deepPurple.withOpacity(0.1),
                  ),
                  child: Center(
                    child: Text(
                      _formatTime(_secondsRemaining),
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  currentExercise.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '${currentExercise.repetitions} repetitions',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 20),
                Image.asset(
                  currentExercise.imageUrl,
                  width: 200,
                  height: 200,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _previousExercise,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(16),
                  ),
                  child: const Icon(Icons.skip_previous, color: Colors.black),
                ),
                ElevatedButton(
                  onPressed: _isRunning ? _pauseTimer : _startTimer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(24),
                  ),
                  child: Icon(
                    _isRunning ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
                ElevatedButton(
                  onPressed: _nextExercise,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(16),
                  ),
                  child: const Icon(Icons.skip_next, color: Colors.black),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class WorkoutCompleteScreen extends StatelessWidget {
  final Workout workout;

  const WorkoutCompleteScreen({super.key, required this.workout});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle,
              size: 100,
              color: Colors.green,
            ),
            const SizedBox(height: 20),
            const Text(
              'Workout Complete!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'You finished ${workout.name}',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 30),
            Text(
              'Total time: ${workout.duration} minutes',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Calories burned: ~${workout.calories} cal',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Done',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryDetailScreen extends StatelessWidget {
  final WorkoutCategory category;

  const CategoryDetailScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final categoryWorkouts = workouts
        .where((workout) => workout.category == category.name)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
      ),
      body: ListView.builder(
        itemCount: categoryWorkouts.length,
        itemBuilder: (context, index) {
          return WorkoutCard(workout: categoryWorkouts[index]);
        },
      ),
    );
  }
}

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favoriteWorkouts = workouts.where((workout) => workout.isFavorite).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: favoriteWorkouts.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.favorite_border,
              size: 60,
              color: Colors.grey,
            ),
            const SizedBox(height: 20),
            const Text(
              'No favorites yet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Tap the heart icon to add workouts to your favorites',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      )
          : ListView.builder(
        itemCount: favoriteWorkouts.length,
        itemBuilder: (context, index) {
          return QuickWorkoutTile(workout: favoriteWorkouts[index]);
        },
      ),
    );
  }
}

class WorkoutPlansScreen extends StatelessWidget {
  const WorkoutPlansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Plans'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          PlanCard(
            title: 'Beginner Full Body',
            description: '4-week plan for beginners',
            duration: '28 days',
            difficulty: 'Easy',
            workouts: workouts.take(3).toList(),
          ),
          const SizedBox(height: 16),
          PlanCard(
            title: 'Intermediate Strength',
            description: '6-week strength building plan',
            duration: '42 days',
            difficulty: 'Medium',
            workouts: workouts.skip(3).take(3).toList(),
          ),
          const SizedBox(height: 16),
          PlanCard(
            title: 'Advanced HIIT',
            description: '8-week high intensity interval training',
            duration: '56 days',
            difficulty: 'Hard',
            workouts: workouts.skip(6).take(3).toList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCreatePlanDialog(context);
        },
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showCreatePlanDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create New Plan'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Plan Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
              ),
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }
}

class PlanCard extends StatelessWidget {
  final String title;
  final String description;
  final String duration;
  final String difficulty;
  final List<Workout> workouts;

  const PlanCard({
    super.key,
    required this.title,
    required this.description,
    required this.duration,
    required this.difficulty,
    required this.workouts,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.timer, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  duration,
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(width: 16),
                Icon(Icons.fitness_center, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  difficulty,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Included Workouts:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Column(
              children: workouts
                  .map((workout) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    const Icon(Icons.play_arrow, size: 16),
                    const SizedBox(width: 8),
                    Text(workout.name),
                  ],
                ),
              ))
                  .toList(),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                ),
                child: const Text('Start Plan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage:
              AssetImage('assets/images/misc/profile_placeholder.avif'),
            ),
            const SizedBox(height: 16),
            const Text(
              'John Doe',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Member since June 2023',
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Stats',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(Icons.bar_chart),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem('Workouts', '24'),
                        _buildStatItem('Hours', '18.5'),
                        _buildStatItem('Calories', '12.4k'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Achievements',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(Icons.emoji_events),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildAchievementItem(
                              'First Workout', Icons.fitness_center),
                          _buildAchievementItem(
                              '5 Day Streak', Icons.local_fire_department),
                          _buildAchievementItem(
                              'Marathon', Icons.directions_run),
                          _buildAchievementItem('Early Bird', Icons.wb_sunny),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Settings',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(Icons.settings),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildSettingsItem(
                        Icons.notifications, 'Notifications', true),
                    _buildSettingsItem(
                        Icons.dark_mode, 'Dark Mode', false),
                    _buildSettingsItem(
                        Icons.volume_up, 'Sound', true),
                    _buildSettingsItem(
                        Icons.privacy_tip, 'Privacy', false),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String title, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildAchievementItem(String title, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.deepPurple.withOpacity(0.1),
            child: Icon(
              icon,
              size: 30,
              color: Colors.deepPurple,
            ),
          ),
          const SizedBox(height: 8),
          Text(title),
        ],
      ),
    );
  }

  Widget _buildSettingsItem(IconData icon, String title, bool isActive) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: Switch(
        value: isActive,
        onChanged: (value) {},
        activeColor: Colors.deepPurple,
      ),
    );
  }
}

class ExerciseSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = workouts
        .where((workout) =>
        workout.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        return QuickWorkoutTile(workout: results[index]);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = query.isEmpty
        ? workouts.take(5).toList()
        : workouts
        .where((workout) =>
        workout.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Image.asset(
            suggestions[index].imageUrl,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
          title: Text(suggestions[index].name),
          onTap: () {
            query = suggestions[index].name;
            showResults(context);
          },
        );
      },
    );
  }
}

// Data Models and Sample Data
class Workout {
  final String id;
  final String name;
  final String imageUrl;
  final String videoUrl;
  final String description;
  final int duration;
  final String difficulty;
  final String category;
  final int calories;
  final bool isFavorite;
  final List<Exercise> exercises;

  Workout({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.videoUrl,
    required this.description,
    required this.duration,
    required this.difficulty,
    required this.category,
    required this.calories,
    this.isFavorite = false,
    required this.exercises,
  });
}

class Exercise {
  final String name;
  final String imageUrl;
  final int duration;
  final String repetitions;
  final List<String> instructions;
  final List<String> tips;

  Exercise({
    required this.name,
    required this.imageUrl,
    required this.duration,
    required this.repetitions,
    required this.instructions,
    required this.tips,
  });
}

class WorkoutCategory {
  final String name;
  final IconData icon;
  final Color color;

  WorkoutCategory({
    required this.name,
    required this.icon,
    required this.color,
  });
}

// Sample data
final workoutCategories = [
  WorkoutCategory(
    name: 'Cardio',
    icon: Icons.directions_run,
    color: Colors.blue,
  ),
  WorkoutCategory(
    name: 'Strength',
    icon: Icons.fitness_center,
    color: Colors.red,
  ),
  WorkoutCategory(
    name: 'Yoga',
    icon: Icons.self_improvement,
    color: Colors.green,
  ),
  WorkoutCategory(
    name: 'HIIT',
    icon: Icons.timer,
    color: Colors.orange,
  ),
  WorkoutCategory(
    name: 'Pilates',
    icon: Icons.accessibility,
    color: Colors.purple,
  ),
  WorkoutCategory(
    name: 'Stretching',
    icon: Icons.open_in_full,
    color: Colors.teal,
  ),
];

final exercises = [
  Exercise(
    name: 'Jumping Jacks',
    imageUrl: 'assets/images/exercises/jumping_jacks.png',
    duration: 30,
    repetitions: '30 reps',
    instructions: [
      'Stand with your feet together and your hands at your sides.',
      'Jump up, spreading your feet shoulder-width apart and raising your arms above your head.',
      'Jump again, returning to the starting position.',
      'Repeat for the specified duration.',
    ],
    tips: [
      'Keep your knees slightly bent to reduce impact.',
      'Maintain a steady pace throughout the exercise.',
    ],
  ),
  Exercise(
    name: 'Push Ups',
    imageUrl: 'assets/images/exercises/push_ups.webp',
    duration: 45,
    repetitions: '15 reps',
    instructions: [
      'Start in a plank position with your hands shoulder-width apart.',
      'Lower your body until your chest nearly touches the floor.',
      'Push yourself back up to the starting position.',
      'Repeat for the specified duration.',
    ],
    tips: [
      'Keep your body in a straight line from head to heels.',
      'Engage your core throughout the movement.',
    ],
  ),
  Exercise(
    name: 'Squats',
    imageUrl: 'assets/images/exercises/squats.webp',
    duration: 40,
    repetitions: '20 reps',
    instructions: [
      'Stand with your feet shoulder-width apart.',
      'Lower your body as if sitting back into a chair.',
      'Keep your chest up and your knees behind your toes.',
      'Push through your heels to return to the starting position.',
      'Repeat for the specified duration.',
    ],
    tips: [
      'Go as low as you can while maintaining good form.',
      'Keep your weight in your heels, not your toes.',
    ],
  ),
  Exercise(
    name: 'Plank',
    imageUrl: 'assets/images/exercises/plank.webp',
    duration: 60,
    repetitions: 'Hold',
    instructions: [
      'Start in a push-up position but with your weight on your forearms.',
      'Keep your body in a straight line from head to heels.',
      'Hold this position for the specified duration.',
    ],
    tips: [
      'Engage your core and glutes to maintain position.',
      'Don\'t let your hips sag or rise too high.',
    ],
  ),
  Exercise(
    name: 'Lunges',
    imageUrl: 'assets/images/exercises/lunges.jpg',
    duration: 45,
    repetitions: '12 reps each leg',
    instructions: [
      'Stand with your feet hip-width apart.',
      'Step forward with one leg and lower your hips until both knees are bent at about 90 degrees.',
      'Push back up to the starting position.',
      'Repeat on the other leg.',
    ],
    tips: [
      'Keep your front knee directly above your ankle.',
      'Don\'t let your knee go past your toes.',
    ],
  ),
  Exercise(
    name: 'Burpees',
    imageUrl: 'assets/images/exercises/burpees.webp',
    duration: 30,
    repetitions: '10 reps',
    instructions: [
      'Start in a standing position.',
      'Drop into a squat position with your hands on the ground.',
      'Kick your feet back into a plank position.',
      'Do a push-up, then return to the plank position.',
      'Jump your feet back to the squat position.',
      'Jump up into the air with your arms overhead.',
    ],
    tips: [
      'Maintain a steady pace throughout the exercise.',
      'Modify by stepping back instead of jumping if needed.',
    ],
  ),
];

final workouts = [
  Workout(
    id: '1',
    name: 'Full Body Burn',
    imageUrl: 'assets/images/workouts/full_body.jpg',
    videoUrl: 'assets/full_body.mp4',
    description:
    'A complete full body workout that targets all major muscle groups for a balanced fitness routine.',
    duration: 30,
    difficulty: 'Intermediate',
    category: 'HIIT',
    calories: 300,
    exercises: exercises.sublist(0, 3),
  ),
  Workout(
    id: '2',
    name: 'Core Crusher',
    imageUrl: 'assets/images/workouts/core.jpg',
    videoUrl: 'assets/core.mp4',
    description:
    'Intense core workout to strengthen your abs, obliques, and lower back.',
    duration: 20,
    difficulty: 'Beginner',
    category: 'Strength',
    calories: 200,
    exercises: exercises.sublist(2, 5),
  ),
  Workout(
    id: '3',
    name: 'Cardio Blast',
    imageUrl: 'assets/images/workouts/cardio.webp',
    videoUrl: 'assets/cardio.mp4',
    description:
    'High energy cardio workout to get your heart pumping and burn calories.',
    duration: 25,
    difficulty: 'Advanced',
    category: 'Cardio',
    calories: 350,
    exercises: [exercises[0], exercises[5], exercises[3]],
  ),
  Workout(
    id: '4',
    name: 'Yoga Flow',
    imageUrl: 'assets/images/workouts/yoga.webp',
    videoUrl: 'assets/yoga.mp4',
    description:
    'Gentle yoga sequence to improve flexibility, balance, and mindfulness.',
    duration: 40,
    difficulty: 'Beginner',
    category: 'Yoga',
    calories: 150,
    exercises: [],
  ),
  Workout(
    id: '5',
    name: 'Leg Day',
    imageUrl: 'assets/images/workouts/legs.jpg',
    videoUrl: 'assets/legs.mp4',
    description:
    'Focus on building strength and endurance in your lower body muscles.',
    duration: 35,
    difficulty: 'Intermediate',
    category: 'Strength',
    calories: 280,
    exercises: [exercises[2], exercises[4], exercises[1]],
  ),
  Workout(
    id: '6',
    name: 'Quick HIIT',
    imageUrl: 'assets/images/workouts/hiit.webp',
    videoUrl: 'assets/hiit.mp4',
    description:
    'Short but intense high-intensity interval training workout for maximum calorie burn.',
    duration: 15,
    difficulty: 'Advanced',
    category: 'HIIT',
    calories: 180,
    exercises: [exercises[5], exercises[0], exercises[3]],
  ),
  Workout(
    id: '7',
    name: 'Morning Stretch',
    imageUrl: 'assets/images/workouts/stretch.avif',
    videoUrl: 'assets/stretch.mp4',
    description:
    'Gentle stretching routine to wake up your body and improve flexibility.',
    duration: 10,
    difficulty: 'Beginner',
    category: 'Stretching',
    calories: 50,
    exercises: [],
  ),
  Workout(
    id: '8',
    name: 'Pilates Basics',
    imageUrl: 'assets/images/workouts/pilates.jpg',
    videoUrl: 'assets/pilates.mp4',
    description:
    'Fundamental pilates exercises to strengthen your core and improve posture.',
    duration: 25,
    difficulty: 'Beginner',
    category: 'Pilates',
    calories: 120,
    exercises: [],
  ),
];

final popularWorkouts = workouts.sublist(0, 4);
final quickWorkouts = workouts.sublist(4, 8);