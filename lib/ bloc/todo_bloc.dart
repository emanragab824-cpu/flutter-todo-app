
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/todo_model.dart';
import '../services/todo_service.dart';

// Events
abstract class TodoEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadTodos extends TodoEvent {}

class AddTodo extends TodoEvent {
  final String title;
  final String description;

  AddTodo(this.title, this.description);

  @override
  List<Object?> get props => [title, description];
}

// States
abstract class TodoState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TodoInitial extends TodoState {}

class TodoLoading extends TodoState {}

class TodoLoaded extends TodoState {
  final List<TodoModel> todos;

  TodoLoaded(this.todos);

  @override
  List<Object?> get props => [todos];
}

class TodoOperationSuccess extends TodoState {}

class TodoFailure extends TodoState {
  final String message;

  TodoFailure(this.message);

  @override
  List<Object?> get props => [message];
}

// Bloc
class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodoService todoService;

  TodoBloc(this.todoService) : super(TodoInitial()) {
    on<LoadTodos>((event, emit) async {
      emit(TodoLoading());

      try {
        final todos = await todoService.getTodos();
        emit(TodoLoaded(todos));
      } catch (e) {
        emit(TodoFailure('Failed to load To-Dos.'));
      }
    });

    on<AddTodo>((event, emit) async {
      emit(TodoLoading());

      try {
        await todoService.addTodo(
          event.title,
          event.description,
        );

        emit(TodoOperationSuccess());

        final todos = await todoService.getTodos();
        emit(TodoLoaded(todos));
      } catch (e) {
        emit(TodoFailure('Failed to save To-Do.'));
      }
    });
  }
}
