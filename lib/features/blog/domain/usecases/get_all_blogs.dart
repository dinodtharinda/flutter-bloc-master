import 'package:flutter_bloc_master/core/error/failures.dart';
import 'package:flutter_bloc_master/core/usecase/usecase.dart';
import 'package:flutter_bloc_master/features/blog/domain/entities/blog.dart';
import 'package:flutter_bloc_master/features/blog/domain/repository/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetAllBlogs implements UseCase<List<Blog>, NoParams> {
  final BlogRepository blogRepository;

  GetAllBlogs(this.blogRepository);

  @override
  Future<Either<Failure, List<Blog>>> call(NoParams params) async {
    return await blogRepository.getAllBlogs();
  }
}
