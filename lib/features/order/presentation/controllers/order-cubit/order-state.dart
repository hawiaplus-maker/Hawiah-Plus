abstract class OrderState {}

class OrderInitial extends OrderState {}

class OrderSuccess extends OrderState {}

class OrderLoading extends OrderState {}

class OrderChange extends OrderState {}

class OrderRebuild extends OrderState {}

class OrderError extends OrderState {}
