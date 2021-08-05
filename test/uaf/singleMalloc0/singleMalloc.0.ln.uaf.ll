; ModuleID = 'singleMalloc.0.ln.uaf.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [32 x i8] c"Value of the 6th integer is %d\0A\00", align 1
@__seahorn_UAF_HEAP_SIZE = local_unnamed_addr constant i64 1048576, align 8, !dbg !0
@__seahorn_MAX_ALLOCATIONS = local_unnamed_addr constant i64 100, align 8, !dbg !12
@__seahorn_UAF_firstFree = local_unnamed_addr global i64 0, align 8, !dbg !16
@__seahorn_allocationCount = local_unnamed_addr global i64 0, align 8, !dbg !22
@__seahorn_UAF_active = local_unnamed_addr global i8 0, align 1, !dbg !24
@__seahorn_UAF_freed = local_unnamed_addr global i8 0, align 1, !dbg !27
@__seahorn_UAF_bgn = common local_unnamed_addr global i8* null, align 8, !dbg !46
@__seahorn_UAF_end = common local_unnamed_addr global i8* null, align 8, !dbg !48
@__seahorn_UAF_heap = common global [1048576 x i8] zeroinitializer, align 16, !dbg !29
@__seahorn_UAF_heap_sizes = common local_unnamed_addr global [100 x i64] zeroinitializer, align 16, !dbg !35
@__seahorn_UAF_shadow_heap = common local_unnamed_addr global [1048576 x i8] zeroinitializer, align 16, !dbg !40
@__seahorn_allocationStarts = common local_unnamed_addr global [100 x i8*] zeroinitializer, align 16, !dbg !42
@.str.1 = private unnamed_addr constant [32 x i8] c"memory allocated at address %p\0A\00", align 1
@.str.1.2 = private unnamed_addr constant [30 x i8] c"freeing memory at address %p\0A\00", align 1
@.str.2 = private unnamed_addr constant [18 x i8] c"using address %p\0A\00", align 1

; Function Attrs: nounwind uwtable
define dso_local i32 @main() #0 {
  call void @__seahorn_UAF_init()
  %1 = call i8* @__seahorn_UAF_malloc4(i64 4)
  %2 = bitcast i8* %1 to i32*
  %3 = call i8* @__seahorn_UAF_malloc4(i64 8)
  %4 = bitcast i8* %3 to i32**
  %5 = bitcast i32* %2 to i8*
  call void @__seahorn_UAF_use_prehook4(i8* %5)
  store i32 0, i32* %2, align 4
  %6 = bitcast i32** %4 to i8*
  call void @llvm.lifetime.start.p0i8(i64 8, i8* %6) #5
  %7 = call noalias i8* @__seahorn_UAF_malloc4(i64 60) #5
  %8 = bitcast i8* %7 to i32*
  %9 = bitcast i32** %4 to i8*
  call void @__seahorn_UAF_use_prehook4(i8* %9)
  store i32* %8, i32** %4, align 8, !tbaa !55
  %10 = bitcast i32** %4 to i8*
  call void @__seahorn_UAF_use_prehook4(i8* %10)
  %11 = load i32*, i32** %4, align 8, !tbaa !55
  %12 = icmp ne i32* %11, null
  br i1 %12, label %13, label %27

13:                                               ; preds = %0
  %14 = bitcast i32** %4 to i8*
  call void @__seahorn_UAF_use_prehook4(i8* %14)
  %15 = load i32*, i32** %4, align 8, !tbaa !55
  %16 = getelementptr inbounds i32, i32* %15, i64 5
  %17 = bitcast i32* %16 to i8*
  call void @__seahorn_UAF_use_prehook4(i8* %17)
  store i32 480, i32* %16, align 4, !tbaa !59
  %18 = bitcast i32** %4 to i8*
  call void @__seahorn_UAF_use_prehook4(i8* %18)
  %19 = load i32*, i32** %4, align 8, !tbaa !55
  %20 = getelementptr inbounds i32, i32* %19, i64 5
  %21 = bitcast i32* %20 to i8*
  call void @__seahorn_UAF_use_prehook4(i8* %21)
  %22 = load i32, i32* %20, align 4, !tbaa !59
  %23 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([32 x i8], [32 x i8]* @.str, i64 0, i64 0), i32 %22)
  %24 = bitcast i32** %4 to i8*
  call void @__seahorn_UAF_use_prehook4(i8* %24)
  %25 = load i32*, i32** %4, align 8, !tbaa !55
  %26 = bitcast i32* %25 to i8*
  call void @__seahorn_UAF_free4(i8* %26) #5
  br label %27

27:                                               ; preds = %13, %0
  %28 = bitcast i32** %4 to i8*
  call void @llvm.lifetime.end.p0i8(i64 8, i8* %28) #5
  %29 = bitcast i32* %2 to i8*
  call void @__seahorn_UAF_use_prehook4(i8* %29)
  %30 = load i32, i32* %2, align 4
  call void @__seahorn_UAF_free4(i8* %3)
  call void @__seahorn_UAF_free4(i8* %1)
  ret i32 %30
}

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #1

declare dso_local i32 @printf(i8*, ...) #2

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: nounwind uwtable
define void @__seahorn_UAF_init() local_unnamed_addr #0 !dbg !61 {
  %1 = tail call i8* @__seahorn_UAF_nondet_ptr() #5, !dbg !64
  store i8* %1, i8** @__seahorn_UAF_bgn, align 8, !dbg !65, !tbaa !55
  %2 = tail call i8* @__seahorn_UAF_nondet_ptr() #5, !dbg !66
  store i8* %2, i8** @__seahorn_UAF_end, align 8, !dbg !67, !tbaa !55
  ret void, !dbg !68
}

declare i8* @__seahorn_UAF_nondet_ptr() local_unnamed_addr #2

; Function Attrs: nounwind uwtable
define i8* @__seahorn_UAF_malloc(i64 %0) local_unnamed_addr #0 !dbg !69 {
  call void @llvm.dbg.value(metadata i64 %0, metadata !73, metadata !DIExpression()), !dbg !75
  %2 = icmp eq i64 %0, 0, !dbg !76
  br i1 %2, label %15, label %3, !dbg !78

3:                                                ; preds = %1
  %4 = tail call zeroext i1 @__seahorn_UAF_nondet() #5, !dbg !79
  br i1 %4, label %15, label %5, !dbg !81

5:                                                ; preds = %3
  %6 = load i64, i64* @__seahorn_UAF_firstFree, align 8, !dbg !82, !tbaa !84
  %7 = sub i64 1048568, %6, !dbg !86
  %8 = icmp ult i64 %7, %0, !dbg !87
  br i1 %8, label %15, label %9, !dbg !88

9:                                                ; preds = %5
  %10 = getelementptr inbounds [1048576 x i8], [1048576 x i8]* @__seahorn_UAF_heap, i64 0, i64 %6, !dbg !89
  call void @llvm.dbg.value(metadata i8* %10, metadata !74, metadata !DIExpression()), !dbg !75
  %11 = add i64 %0, 8, !dbg !90
  %12 = add i64 %11, %6, !dbg !91
  store i64 %12, i64* @__seahorn_UAF_firstFree, align 8, !dbg !91, !tbaa !84
  %13 = bitcast i8* %10 to i64*, !dbg !92
  store i64 %0, i64* %13, align 8, !dbg !93, !tbaa !84
  %14 = getelementptr inbounds i8, i8* %10, i64 8, !dbg !94
  br label %15, !dbg !95

15:                                               ; preds = %9, %5, %3, %1
  %16 = phi i8* [ %14, %9 ], [ null, %1 ], [ null, %3 ], [ null, %5 ], !dbg !75
  ret i8* %16, !dbg !96
}

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #3

declare zeroext i1 @__seahorn_UAF_nondet() local_unnamed_addr #2

; Function Attrs: noinline nounwind optnone uwtable
define i8* @__seahorn_UAF_malloc2(i64 %0) local_unnamed_addr #4 !dbg !97 {
  %2 = alloca i8*, align 8
  %3 = alloca i64, align 8
  %4 = alloca i8*, align 8
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store i64 %0, i64* %3, align 8, !tbaa !84
  call void @llvm.dbg.declare(metadata i64* %3, metadata !99, metadata !DIExpression()), !dbg !104
  %7 = bitcast i8** %4 to i8*, !dbg !105
  call void @llvm.lifetime.start.p0i8(i64 8, i8* %7) #5, !dbg !105
  call void @llvm.dbg.declare(metadata i8** %4, metadata !100, metadata !DIExpression()), !dbg !106
  %8 = load i64, i64* %3, align 8, !dbg !107, !tbaa !84
  %9 = icmp eq i64 %8, 0, !dbg !109
  br i1 %9, label %10, label %11, !dbg !110

10:                                               ; preds = %1
  store i8* null, i8** %2, align 8, !dbg !111
  store i32 1, i32* %5, align 4
  br label %43, !dbg !111

11:                                               ; preds = %1
  %12 = load i64, i64* %3, align 8, !dbg !112, !tbaa !84
  %13 = load i64, i64* @__seahorn_UAF_firstFree, align 8, !dbg !113, !tbaa !84
  %14 = sub i64 1048576, %13, !dbg !114
  %15 = icmp ule i64 %12, %14, !dbg !115
  call void @__SEA_assume(i1 zeroext %15), !dbg !116
  %16 = load i64, i64* @__seahorn_UAF_firstFree, align 8, !dbg !117, !tbaa !84
  %17 = getelementptr inbounds [1048576 x i8], [1048576 x i8]* @__seahorn_UAF_heap, i64 0, i64 %16, !dbg !118
  store i8* %17, i8** %4, align 8, !dbg !119, !tbaa !55
  %18 = load i64, i64* %3, align 8, !dbg !120, !tbaa !84
  %19 = load i64, i64* @__seahorn_UAF_firstFree, align 8, !dbg !121, !tbaa !84
  %20 = getelementptr inbounds [100 x i64], [100 x i64]* @__seahorn_UAF_heap_sizes, i64 0, i64 %19, !dbg !122
  store i64 %18, i64* %20, align 8, !dbg !123, !tbaa !84
  %21 = bitcast i32* %6 to i8*, !dbg !124
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %21) #5, !dbg !124
  call void @llvm.dbg.declare(metadata i32* %6, metadata !101, metadata !DIExpression()), !dbg !125
  store i32 0, i32* %6, align 4, !dbg !125, !tbaa !59
  br label %22, !dbg !124

22:                                               ; preds = %35, %11
  %23 = load i32, i32* %6, align 4, !dbg !126, !tbaa !59
  %24 = sext i32 %23 to i64, !dbg !126
  %25 = load i64, i64* %3, align 8, !dbg !128, !tbaa !84
  %26 = icmp ult i64 %24, %25, !dbg !129
  br i1 %26, label %29, label %27, !dbg !130

27:                                               ; preds = %22
  store i32 2, i32* %5, align 4
  %28 = bitcast i32* %6 to i8*, !dbg !131
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %28) #5, !dbg !131
  br label %38

29:                                               ; preds = %22
  %30 = load i64, i64* @__seahorn_UAF_firstFree, align 8, !dbg !132, !tbaa !84
  %31 = load i32, i32* %6, align 4, !dbg !134, !tbaa !59
  %32 = sext i32 %31 to i64, !dbg !134
  %33 = add i64 %30, %32, !dbg !135
  %34 = getelementptr inbounds [1048576 x i8], [1048576 x i8]* @__seahorn_UAF_shadow_heap, i64 0, i64 %33, !dbg !136
  store i8 1, i8* %34, align 1, !dbg !137, !tbaa !138
  br label %35, !dbg !139

35:                                               ; preds = %29
  %36 = load i32, i32* %6, align 4, !dbg !140, !tbaa !59
  %37 = add nsw i32 %36, 1, !dbg !140
  store i32 %37, i32* %6, align 4, !dbg !140, !tbaa !59
  br label %22, !dbg !131, !llvm.loop !141

38:                                               ; preds = %27
  %39 = load i64, i64* %3, align 8, !dbg !143, !tbaa !84
  %40 = load i64, i64* @__seahorn_UAF_firstFree, align 8, !dbg !144, !tbaa !84
  %41 = add i64 %40, %39, !dbg !144
  store i64 %41, i64* @__seahorn_UAF_firstFree, align 8, !dbg !144, !tbaa !84
  %42 = load i8*, i8** %4, align 8, !dbg !145, !tbaa !55
  store i8* %42, i8** %2, align 8, !dbg !146
  store i32 1, i32* %5, align 4
  br label %43, !dbg !146

43:                                               ; preds = %38, %10
  %44 = bitcast i8** %4 to i8*, !dbg !147
  call void @llvm.lifetime.end.p0i8(i64 8, i8* %44) #5, !dbg !147
  %45 = load i8*, i8** %2, align 8, !dbg !147
  ret i8* %45, !dbg !147
}

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #3

declare void @__SEA_assume(i1 zeroext) local_unnamed_addr #2

; Function Attrs: nounwind uwtable
define i8* @__seahorn_UAF_malloc3(i64 %0) local_unnamed_addr #0 !dbg !148 {
  call void @llvm.dbg.value(metadata i64 %0, metadata !150, metadata !DIExpression()), !dbg !152
  %2 = icmp eq i64 %0, 0, !dbg !153
  br i1 %2, label %18, label %3, !dbg !155

3:                                                ; preds = %1
  %4 = load i64, i64* @__seahorn_UAF_firstFree, align 8, !dbg !156, !tbaa !84
  %5 = sub i64 1048576, %4, !dbg !157
  %6 = icmp ugt i64 %5, %0, !dbg !158
  tail call void @__SEA_assume(i1 zeroext %6) #5, !dbg !159
  %7 = load i64, i64* @__seahorn_allocationCount, align 8, !dbg !160, !tbaa !84
  %8 = icmp ult i64 %7, 100, !dbg !161
  tail call void @__SEA_assume(i1 zeroext %8) #5, !dbg !162
  %9 = load i64, i64* @__seahorn_UAF_firstFree, align 8, !dbg !163, !tbaa !84
  %10 = getelementptr inbounds [1048576 x i8], [1048576 x i8]* @__seahorn_UAF_heap, i64 0, i64 %9, !dbg !164
  call void @llvm.dbg.value(metadata i8* %10, metadata !151, metadata !DIExpression()), !dbg !152
  %11 = load i64, i64* @__seahorn_allocationCount, align 8, !dbg !165, !tbaa !84
  %12 = getelementptr inbounds [100 x i64], [100 x i64]* @__seahorn_UAF_heap_sizes, i64 0, i64 %11, !dbg !166
  store i64 1, i64* %12, align 8, !dbg !167, !tbaa !84
  %13 = getelementptr inbounds [100 x i8*], [100 x i8*]* @__seahorn_allocationStarts, i64 0, i64 %11, !dbg !168
  store i8* %10, i8** %13, align 8, !dbg !169, !tbaa !55
  %14 = add i64 %9, %0, !dbg !170
  store i64 %14, i64* @__seahorn_UAF_firstFree, align 8, !dbg !170, !tbaa !84
  %15 = add i64 %11, 1, !dbg !171
  store i64 %15, i64* @__seahorn_allocationCount, align 8, !dbg !171, !tbaa !84
  %16 = getelementptr inbounds [100 x i8*], [100 x i8*]* @__seahorn_allocationStarts, i64 0, i64 %15, !dbg !172
  store i8* null, i8** %16, align 8, !dbg !173, !tbaa !55
  %17 = tail call i32 (i8*, ...) @printf(i8* nonnull dereferenceable(1) getelementptr inbounds ([32 x i8], [32 x i8]* @.str.1, i64 0, i64 0), i8* nonnull %10), !dbg !174
  br label %18, !dbg !175

18:                                               ; preds = %3, %1
  %19 = phi i8* [ %10, %3 ], [ null, %1 ], !dbg !152
  ret i8* %19, !dbg !176
}

; Function Attrs: nounwind uwtable
define i8* @__seahorn_UAF_malloc4(i64 %0) local_unnamed_addr #0 !dbg !177 {
  call void @llvm.dbg.value(metadata i64 %0, metadata !179, metadata !DIExpression()), !dbg !181
  %2 = load i64, i64* @__seahorn_UAF_firstFree, align 8, !dbg !182, !tbaa !84
  %3 = sub i64 1048576, %2, !dbg !183
  %4 = icmp ugt i64 %3, %0, !dbg !184
  tail call void @__SEA_assume(i1 zeroext %4) #5, !dbg !185
  %5 = tail call i8* @__seahorn_UAF_malloc_redir(i64 %0) #5, !dbg !186
  call void @llvm.dbg.value(metadata i8* %5, metadata !180, metadata !DIExpression()), !dbg !181
  %6 = load i8, i8* @__seahorn_UAF_active, align 1, !dbg !187, !tbaa !189, !range !191
  %7 = icmp eq i8 %6, 0, !dbg !187
  br i1 %7, label %8, label %15, !dbg !192

8:                                                ; preds = %1
  %9 = tail call zeroext i1 @__seahorn_UAF_nondet() #5, !dbg !193
  br i1 %9, label %10, label %15, !dbg !194

10:                                               ; preds = %8
  store i8 1, i8* @__seahorn_UAF_active, align 1, !dbg !195, !tbaa !189
  %11 = load i8*, i8** @__seahorn_UAF_bgn, align 8, !dbg !197, !tbaa !55
  %12 = icmp eq i8* %11, %5, !dbg !198
  tail call void @__SEA_assume(i1 zeroext %12) #5, !dbg !199
  %13 = getelementptr inbounds i8, i8* %5, i64 %0, !dbg !200
  store i8* %13, i8** @__seahorn_UAF_end, align 8, !dbg !201, !tbaa !55
  %14 = icmp ne i8* %5, null, !dbg !202
  br label %18, !dbg !203

15:                                               ; preds = %8, %1
  %16 = load i8*, i8** @__seahorn_UAF_bgn, align 8, !dbg !204, !tbaa !55
  %17 = icmp ult i8* %5, %16, !dbg !206
  br label %18

18:                                               ; preds = %15, %10
  %19 = phi i1 [ %17, %15 ], [ %14, %10 ]
  tail call void @__SEA_assume(i1 zeroext %19) #5, !dbg !207
  ret i8* %5, !dbg !208
}

declare i8* @__seahorn_UAF_malloc_redir(i64) local_unnamed_addr #2

; Function Attrs: nounwind uwtable
define i8* @__seahorn_UAF_calloc(i64 %0, i64 %1) local_unnamed_addr #0 !dbg !209 {
  call void @llvm.dbg.value(metadata i64 %0, metadata !213, metadata !DIExpression()), !dbg !217
  call void @llvm.dbg.value(metadata i64 %1, metadata !214, metadata !DIExpression()), !dbg !217
  %3 = tail call { i64, i1 } @llvm.umul.with.overflow.i64(i64 %0, i64 %1), !dbg !218
  %4 = extractvalue { i64, i1 } %3, 0, !dbg !218
  call void @llvm.dbg.value(metadata i64 %4, metadata !216, metadata !DIExpression()), !dbg !217
  %5 = icmp eq i64 %0, 0, !dbg !219
  br i1 %5, label %10, label %6, !dbg !221

6:                                                ; preds = %2
  %7 = extractvalue { i64, i1 } %3, 1, !dbg !218
  %8 = icmp eq i64 %4, 0, !dbg !222
  %9 = or i1 %7, %8, !dbg !224
  call void @llvm.dbg.value(metadata i64 %4, metadata !73, metadata !DIExpression()) #5, !dbg !225
  br i1 %9, label %24, label %12, !dbg !224

10:                                               ; preds = %2
  call void @llvm.dbg.value(metadata i64 %4, metadata !73, metadata !DIExpression()) #5, !dbg !225
  %11 = icmp eq i64 %4, 0, !dbg !222
  br i1 %11, label %24, label %12, !dbg !226

12:                                               ; preds = %10, %6
  %13 = tail call zeroext i1 @__seahorn_UAF_nondet() #5, !dbg !227
  br i1 %13, label %24, label %14, !dbg !228

14:                                               ; preds = %12
  %15 = load i64, i64* @__seahorn_UAF_firstFree, align 8, !dbg !229, !tbaa !84
  %16 = sub i64 1048568, %15, !dbg !230
  %17 = icmp ult i64 %16, %4, !dbg !231
  br i1 %17, label %24, label %18, !dbg !232

18:                                               ; preds = %14
  %19 = getelementptr inbounds [1048576 x i8], [1048576 x i8]* @__seahorn_UAF_heap, i64 0, i64 %15, !dbg !233
  call void @llvm.dbg.value(metadata i8* %19, metadata !74, metadata !DIExpression()) #5, !dbg !225
  %20 = add i64 %4, 8, !dbg !234
  %21 = add i64 %20, %15, !dbg !235
  store i64 %21, i64* @__seahorn_UAF_firstFree, align 8, !dbg !235, !tbaa !84
  %22 = bitcast i8* %19 to i64*, !dbg !236
  store i64 %4, i64* %22, align 8, !dbg !237, !tbaa !84
  %23 = getelementptr inbounds i8, i8* %19, i64 8, !dbg !238
  br label %24, !dbg !239

24:                                               ; preds = %18, %14, %12, %10, %6
  %25 = phi i8* [ null, %6 ], [ %23, %18 ], [ null, %10 ], [ null, %12 ], [ null, %14 ], !dbg !217
  ret i8* %25, !dbg !240
}

; Function Attrs: nounwind readnone speculatable willreturn
declare { i64, i1 } @llvm.umul.with.overflow.i64(i64, i64) #3

; Function Attrs: nounwind uwtable
define void @__seahorn_UAF_free(i8* %0) local_unnamed_addr #0 !dbg !241 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !245, metadata !DIExpression()), !dbg !246
  %2 = icmp eq i8* %0, null, !dbg !247
  br i1 %2, label %10, label %3, !dbg !249

3:                                                ; preds = %1
  %4 = getelementptr inbounds i8, i8* %0, i64 -8, !dbg !250
  call void @llvm.dbg.value(metadata i8* %4, metadata !245, metadata !DIExpression()), !dbg !246
  %5 = bitcast i8* %4 to i64*, !dbg !251
  %6 = load i64, i64* %5, align 8, !dbg !251, !tbaa !84
  %7 = icmp eq i64 %6, 0, !dbg !251
  br i1 %7, label %8, label %9, !dbg !251

8:                                                ; preds = %3
  tail call void @__VERIFIER_error() #5, !dbg !251
  br label %9, !dbg !251

9:                                                ; preds = %8, %3
  store i64 0, i64* %5, align 8, !dbg !252, !tbaa !84
  br label %10, !dbg !253

10:                                               ; preds = %9, %1
  ret void, !dbg !253
}

declare void @__VERIFIER_error() local_unnamed_addr #2

; Function Attrs: nounwind uwtable
define void @__seahorn_UAF_free2(i8* %0) local_unnamed_addr #0 !dbg !254 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !256, metadata !DIExpression()), !dbg !261
  %2 = icmp eq i8* %0, null, !dbg !262
  br i1 %2, label %20, label %3, !dbg !264

3:                                                ; preds = %1
  %4 = ptrtoint i8* %0 to i64, !dbg !265
  %5 = sub i64 %4, ptrtoint ([1048576 x i8]* @__seahorn_UAF_heap to i64), !dbg !265
  call void @llvm.dbg.value(metadata i64 %5, metadata !257, metadata !DIExpression()), !dbg !261
  %6 = getelementptr inbounds [100 x i64], [100 x i64]* @__seahorn_UAF_heap_sizes, i64 0, i64 %5, !dbg !266
  %7 = load i64, i64* %6, align 8, !dbg !266, !tbaa !84
  call void @llvm.dbg.value(metadata i64 %7, metadata !258, metadata !DIExpression()), !dbg !261
  %8 = icmp eq i64 %7, 0, !dbg !267
  br i1 %8, label %9, label %10, !dbg !267

9:                                                ; preds = %3
  tail call void @__VERIFIER_error() #5, !dbg !267
  call void @llvm.dbg.value(metadata i32 0, metadata !259, metadata !DIExpression()), !dbg !268
  br label %20, !dbg !269

10:                                               ; preds = %17, %3
  %11 = phi i64 [ %18, %17 ], [ 0, %3 ]
  call void @llvm.dbg.value(metadata i64 %11, metadata !259, metadata !DIExpression()), !dbg !268
  %12 = add i64 %11, %5, !dbg !270
  %13 = getelementptr inbounds [1048576 x i8], [1048576 x i8]* @__seahorn_UAF_shadow_heap, i64 0, i64 %12, !dbg !270
  %14 = load i8, i8* %13, align 1, !dbg !270, !tbaa !138
  %15 = icmp eq i8 %14, 0, !dbg !270
  br i1 %15, label %16, label %17, !dbg !270

16:                                               ; preds = %10
  tail call void @__VERIFIER_error() #5, !dbg !270
  br label %17, !dbg !270

17:                                               ; preds = %16, %10
  store i8 0, i8* %13, align 1, !dbg !273, !tbaa !138
  %18 = add nuw i64 %11, 1, !dbg !274
  call void @llvm.dbg.value(metadata i64 %18, metadata !259, metadata !DIExpression()), !dbg !268
  %19 = icmp eq i64 %18, %7, !dbg !275
  br i1 %19, label %20, label %10, !dbg !269, !llvm.loop !276

20:                                               ; preds = %17, %9, %1
  ret void, !dbg !278
}

; Function Attrs: nounwind uwtable
define void @__seahorn_UAF_free3(i8* %0) local_unnamed_addr #0 !dbg !279 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !281, metadata !DIExpression()), !dbg !284
  %2 = tail call i32 (i8*, ...) @printf(i8* nonnull dereferenceable(1) getelementptr inbounds ([30 x i8], [30 x i8]* @.str.1.2, i64 0, i64 0), i8* %0), !dbg !285
  %3 = icmp eq i8* %0, null, !dbg !286
  br i1 %3, label %30, label %4, !dbg !288

4:                                                ; preds = %1
  %5 = ptrtoint i8* %0 to i64, !dbg !284
  %6 = load i64, i64* @__seahorn_allocationCount, align 8, !dbg !284
  br label %7, !dbg !289

7:                                                ; preds = %7, %4
  %8 = phi i64 [ %15, %7 ], [ 0, %4 ], !dbg !284
  call void @llvm.dbg.value(metadata i64 %8, metadata !282, metadata !DIExpression()), !dbg !284
  %9 = getelementptr inbounds [100 x i8*], [100 x i8*]* @__seahorn_allocationStarts, i64 0, i64 %8, !dbg !290
  %10 = bitcast i8** %9 to i64*, !dbg !290
  %11 = load i64, i64* %10, align 8, !dbg !290, !tbaa !55
  %12 = icmp ule i64 %11, %5, !dbg !291
  %13 = icmp ugt i64 %6, %8, !dbg !292
  %14 = and i1 %12, %13, !dbg !292
  %15 = add nuw i64 %8, 1, !dbg !293
  call void @llvm.dbg.value(metadata i64 %15, metadata !282, metadata !DIExpression()), !dbg !284
  br i1 %14, label %7, label %16, !dbg !289, !llvm.loop !295

16:                                               ; preds = %7
  call void @llvm.dbg.value(metadata i64 %8, metadata !282, metadata !DIExpression()), !dbg !284
  call void @llvm.dbg.value(metadata i64 %8, metadata !282, metadata !DIExpression()), !dbg !284
  call void @llvm.dbg.value(metadata i64 %8, metadata !282, metadata !DIExpression()), !dbg !284
  call void @llvm.dbg.value(metadata i64 %8, metadata !282, metadata !DIExpression()), !dbg !284
  call void @llvm.dbg.value(metadata i64 %8, metadata !282, metadata !DIExpression(DW_OP_LLVM_convert, 64, DW_ATE_unsigned, DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_stack_value)), !dbg !284
  call void @llvm.dbg.value(metadata i64 %8, metadata !282, metadata !DIExpression(DW_OP_LLVM_convert, 64, DW_ATE_unsigned, DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_stack_value)), !dbg !284
  call void @llvm.dbg.value(metadata i64 %8, metadata !282, metadata !DIExpression(DW_OP_LLVM_convert, 64, DW_ATE_unsigned, DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_constu, 1, DW_OP_minus, DW_OP_stack_value)), !dbg !284
  %17 = shl i64 %8, 32, !dbg !297
  %18 = add i64 %17, -4294967296, !dbg !297
  %19 = ashr exact i64 %18, 32, !dbg !297
  %20 = getelementptr inbounds [100 x i8*], [100 x i8*]* @__seahorn_allocationStarts, i64 0, i64 %19, !dbg !297
  %21 = load i8*, i8** %20, align 8, !dbg !297, !tbaa !55
  %22 = icmp eq i8* %21, %0, !dbg !297
  br i1 %22, label %24, label %23, !dbg !297

23:                                               ; preds = %16
  tail call void @__VERIFIER_error() #5, !dbg !297
  br label %24, !dbg !297

24:                                               ; preds = %23, %16
  %25 = getelementptr inbounds [100 x i64], [100 x i64]* @__seahorn_UAF_heap_sizes, i64 0, i64 %19, !dbg !298
  %26 = load i64, i64* %25, align 8, !dbg !298, !tbaa !84
  call void @llvm.dbg.value(metadata i64 %26, metadata !283, metadata !DIExpression()), !dbg !284
  %27 = icmp eq i64 %26, 0, !dbg !299
  br i1 %27, label %28, label %29, !dbg !299

28:                                               ; preds = %24
  tail call void @__VERIFIER_error() #5, !dbg !299
  br label %29, !dbg !299

29:                                               ; preds = %28, %24
  store i64 0, i64* %25, align 8, !dbg !300, !tbaa !84
  br label %30

30:                                               ; preds = %29, %1
  ret void, !dbg !301
}

; Function Attrs: nounwind uwtable
define void @__seahorn_UAF_free4(i8* nocapture readnone %0) local_unnamed_addr #0 !dbg !302 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !304, metadata !DIExpression()), !dbg !305
  %2 = load i8, i8* @__seahorn_UAF_active, align 1, !dbg !306, !tbaa !189, !range !191
  %3 = icmp ne i8 %2, 0, !dbg !306
  %4 = load i8*, i8** @__seahorn_UAF_bgn, align 8, !dbg !308
  %5 = icmp eq i8* %4, %0, !dbg !309
  %6 = and i1 %3, %5, !dbg !310
  br i1 %6, label %7, label %14, !dbg !310

7:                                                ; preds = %1
  %8 = load i8*, i8** @__seahorn_UAF_end, align 8, !dbg !311, !tbaa !55
  %9 = icmp uge i8* %8, %0, !dbg !313
  tail call void @__SEA_assume(i1 zeroext %9) #5, !dbg !314
  %10 = load i8, i8* @__seahorn_UAF_freed, align 1, !dbg !315, !tbaa !189, !range !191
  %11 = icmp eq i8 %10, 0, !dbg !315
  br i1 %11, label %13, label %12, !dbg !315

12:                                               ; preds = %7
  tail call void @__VERIFIER_error() #5, !dbg !315
  br label %13, !dbg !315

13:                                               ; preds = %12, %7
  store i8 1, i8* @__seahorn_UAF_freed, align 1, !dbg !316, !tbaa !189
  br label %14, !dbg !317

14:                                               ; preds = %13, %1
  ret void, !dbg !318
}

; Function Attrs: nounwind uwtable
define i8* @__seahorn_UAF_realloc(i8* %0, i64 %1) local_unnamed_addr #0 !dbg !319 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !323, metadata !DIExpression()), !dbg !329
  call void @llvm.dbg.value(metadata i64 %1, metadata !324, metadata !DIExpression()), !dbg !329
  call void @llvm.dbg.value(metadata i8* null, metadata !325, metadata !DIExpression()), !dbg !329
  %3 = icmp eq i8* %0, null, !dbg !330
  %4 = icmp eq i64 %1, 0, !dbg !329
  br i1 %3, label %5, label %18, !dbg !332

5:                                                ; preds = %2
  call void @llvm.dbg.value(metadata i64 %1, metadata !73, metadata !DIExpression()) #5, !dbg !333
  br i1 %4, label %47, label %6, !dbg !335

6:                                                ; preds = %5
  %7 = tail call zeroext i1 @__seahorn_UAF_nondet() #5, !dbg !336
  br i1 %7, label %47, label %8, !dbg !337

8:                                                ; preds = %6
  %9 = load i64, i64* @__seahorn_UAF_firstFree, align 8, !dbg !338, !tbaa !84
  %10 = sub i64 1048568, %9, !dbg !339
  %11 = icmp ult i64 %10, %1, !dbg !340
  br i1 %11, label %47, label %12, !dbg !341

12:                                               ; preds = %8
  %13 = getelementptr inbounds [1048576 x i8], [1048576 x i8]* @__seahorn_UAF_heap, i64 0, i64 %9, !dbg !342
  call void @llvm.dbg.value(metadata i8* %13, metadata !74, metadata !DIExpression()) #5, !dbg !333
  %14 = add i64 %1, 8, !dbg !343
  %15 = add i64 %14, %9, !dbg !344
  store i64 %15, i64* @__seahorn_UAF_firstFree, align 8, !dbg !344, !tbaa !84
  %16 = bitcast i8* %13 to i64*, !dbg !345
  store i64 %1, i64* %16, align 8, !dbg !346, !tbaa !84
  %17 = getelementptr inbounds i8, i8* %13, i64 8, !dbg !347
  br label %47, !dbg !348

18:                                               ; preds = %2
  br i1 %4, label %19, label %26, !dbg !349

19:                                               ; preds = %18
  call void @llvm.dbg.value(metadata i8* %0, metadata !245, metadata !DIExpression()) #5, !dbg !350
  %20 = getelementptr inbounds i8, i8* %0, i64 -8, !dbg !354
  call void @llvm.dbg.value(metadata i8* %20, metadata !245, metadata !DIExpression()) #5, !dbg !350
  %21 = bitcast i8* %20 to i64*, !dbg !355
  %22 = load i64, i64* %21, align 8, !dbg !355, !tbaa !84
  %23 = icmp eq i64 %22, 0, !dbg !355
  br i1 %23, label %24, label %25, !dbg !355

24:                                               ; preds = %19
  tail call void @__VERIFIER_error() #5, !dbg !355
  br label %25, !dbg !355

25:                                               ; preds = %24, %19
  store i64 0, i64* %21, align 8, !dbg !356, !tbaa !84
  call void @llvm.dbg.value(metadata i64 0, metadata !73, metadata !DIExpression()), !dbg !357
  br label %47, !dbg !359

26:                                               ; preds = %18
  call void @llvm.dbg.value(metadata i64 %1, metadata !73, metadata !DIExpression()) #5, !dbg !360
  %27 = tail call zeroext i1 @__seahorn_UAF_nondet() #5, !dbg !362
  br i1 %27, label %47, label %28, !dbg !363

28:                                               ; preds = %26
  %29 = load i64, i64* @__seahorn_UAF_firstFree, align 8, !dbg !364, !tbaa !84
  %30 = sub i64 1048568, %29, !dbg !365
  %31 = icmp ult i64 %30, %1, !dbg !366
  br i1 %31, label %47, label %32, !dbg !367

32:                                               ; preds = %28
  %33 = getelementptr inbounds [1048576 x i8], [1048576 x i8]* @__seahorn_UAF_heap, i64 0, i64 %29, !dbg !368
  call void @llvm.dbg.value(metadata i8* %33, metadata !74, metadata !DIExpression()) #5, !dbg !360
  %34 = add i64 %1, 8, !dbg !369
  %35 = add i64 %34, %29, !dbg !370
  store i64 %35, i64* @__seahorn_UAF_firstFree, align 8, !dbg !370, !tbaa !84
  %36 = bitcast i8* %33 to i64*, !dbg !371
  store i64 %1, i64* %36, align 8, !dbg !372, !tbaa !84
  %37 = getelementptr inbounds i8, i8* %33, i64 8, !dbg !373
  call void @llvm.dbg.value(metadata i8* %37, metadata !325, metadata !DIExpression()), !dbg !329
  %38 = getelementptr i8, i8* %0, i64 -8, !dbg !374
  %39 = bitcast i8* %38 to i64*, !dbg !375
  %40 = load i64, i64* %39, align 8, !dbg !376, !tbaa !84
  call void @llvm.dbg.value(metadata i64 %40, metadata !326, metadata !DIExpression()), !dbg !377
  %41 = icmp ult i64 %40, %1, !dbg !378
  %42 = select i1 %41, i64 %40, i64 %1, !dbg !379
  tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 1 %37, i8* nonnull align 1 %0, i64 %42, i1 false), !dbg !380
  call void @llvm.dbg.value(metadata i8* %0, metadata !245, metadata !DIExpression()) #5, !dbg !381
  call void @llvm.dbg.value(metadata i8* %38, metadata !245, metadata !DIExpression()) #5, !dbg !381
  %43 = load i64, i64* %39, align 8, !dbg !383, !tbaa !84
  %44 = icmp eq i64 %43, 0, !dbg !383
  br i1 %44, label %45, label %46, !dbg !383

45:                                               ; preds = %32
  tail call void @__VERIFIER_error() #5, !dbg !383
  br label %46, !dbg !383

46:                                               ; preds = %45, %32
  store i64 0, i64* %39, align 8, !dbg !384, !tbaa !84
  br label %47, !dbg !385

47:                                               ; preds = %46, %28, %26, %25, %12, %8, %6, %5
  %48 = phi i8* [ null, %25 ], [ %37, %46 ], [ %17, %12 ], [ null, %5 ], [ null, %6 ], [ null, %8 ], [ null, %26 ], [ null, %28 ], !dbg !329
  ret i8* %48, !dbg !386
}

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg) #1

; Function Attrs: nounwind uwtable
define void @__seahorn_UAF_use_prehook(i8* nocapture readonly %0) local_unnamed_addr #0 !dbg !387 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !389, metadata !DIExpression()), !dbg !390
  %2 = getelementptr inbounds i8, i8* %0, i64 -8, !dbg !391
  call void @llvm.dbg.value(metadata i8* %2, metadata !389, metadata !DIExpression()), !dbg !390
  %3 = bitcast i8* %2 to i64*, !dbg !392
  %4 = load i64, i64* %3, align 8, !dbg !392, !tbaa !84
  %5 = icmp eq i64 %4, 0, !dbg !392
  br i1 %5, label %6, label %7, !dbg !392

6:                                                ; preds = %1
  tail call void @__VERIFIER_error() #5, !dbg !392
  br label %7, !dbg !392

7:                                                ; preds = %6, %1
  ret void, !dbg !393
}

; Function Attrs: nounwind uwtable
define void @__seahorn_UAF_use_prehook2(i8* %0) local_unnamed_addr #0 !dbg !394 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !396, metadata !DIExpression()), !dbg !397
  %2 = ptrtoint i8* %0 to i64, !dbg !398
  %3 = sub i64 %2, ptrtoint ([1048576 x i8]* @__seahorn_UAF_heap to i64), !dbg !398
  %4 = getelementptr inbounds [1048576 x i8], [1048576 x i8]* @__seahorn_UAF_shadow_heap, i64 0, i64 %3, !dbg !398
  %5 = load i8, i8* %4, align 1, !dbg !398, !tbaa !138
  %6 = icmp eq i8 %5, 0, !dbg !398
  br i1 %6, label %7, label %8, !dbg !398

7:                                                ; preds = %1
  tail call void @__VERIFIER_error() #5, !dbg !398
  br label %8, !dbg !398

8:                                                ; preds = %7, %1
  ret void, !dbg !399
}

; Function Attrs: nounwind uwtable
define void @__seahorn_UAF_use_prehook3(i8* %0) local_unnamed_addr #0 !dbg !400 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !402, metadata !DIExpression()), !dbg !407
  %2 = tail call i32 (i8*, ...) @printf(i8* nonnull dereferenceable(1) getelementptr inbounds ([18 x i8], [18 x i8]* @.str.2, i64 0, i64 0), i8* %0), !dbg !408
  call void @llvm.dbg.value(metadata i32 0, metadata !403, metadata !DIExpression()), !dbg !407
  call void @llvm.dbg.value(metadata i8 0, metadata !405, metadata !DIExpression()), !dbg !407
  %3 = ptrtoint i8* %0 to i64, !dbg !407
  %4 = load i64, i64* @__seahorn_allocationCount, align 8, !dbg !407
  call void @llvm.dbg.value(metadata i8 undef, metadata !405, metadata !DIExpression()), !dbg !407
  %5 = load i64, i64* bitcast ([100 x i8*]* @__seahorn_allocationStarts to i64*), align 16, !dbg !409, !tbaa !55
  %6 = icmp ule i64 %5, %3, !dbg !410
  %7 = icmp ne i64 %4, 0, !dbg !411
  %8 = and i1 %6, %7, !dbg !411
  call void @llvm.dbg.value(metadata i32 1, metadata !403, metadata !DIExpression()), !dbg !407
  call void @llvm.dbg.value(metadata i8 1, metadata !405, metadata !DIExpression()), !dbg !407
  br i1 %8, label %9, label %19, !dbg !412

9:                                                ; preds = %9, %1
  %10 = phi i32 [ %18, %9 ], [ 1, %1 ], !dbg !407
  call void @llvm.dbg.value(metadata i32 %10, metadata !403, metadata !DIExpression()), !dbg !407
  call void @llvm.dbg.value(metadata i8 undef, metadata !405, metadata !DIExpression()), !dbg !407
  %11 = zext i32 %10 to i64, !dbg !409
  %12 = getelementptr inbounds [100 x i8*], [100 x i8*]* @__seahorn_allocationStarts, i64 0, i64 %11, !dbg !409
  %13 = bitcast i8** %12 to i64*, !dbg !409
  %14 = load i64, i64* %13, align 8, !dbg !409, !tbaa !55
  %15 = icmp ule i64 %14, %3, !dbg !410
  %16 = icmp ugt i64 %4, %11, !dbg !411
  %17 = and i1 %15, %16, !dbg !411
  %18 = add i32 %10, 1, !dbg !413
  call void @llvm.dbg.value(metadata i32 %18, metadata !403, metadata !DIExpression()), !dbg !407
  call void @llvm.dbg.value(metadata i8 1, metadata !405, metadata !DIExpression()), !dbg !407
  br i1 %17, label %9, label %19, !dbg !412, !llvm.loop !415

19:                                               ; preds = %9, %1
  %20 = phi i1 [ false, %1 ], [ true, %9 ]
  %21 = phi i32 [ 0, %1 ], [ %10, %9 ], !dbg !407
  call void @llvm.dbg.value(metadata i32 %21, metadata !403, metadata !DIExpression()), !dbg !407
  call void @llvm.dbg.value(metadata i32 %21, metadata !403, metadata !DIExpression()), !dbg !407
  call void @llvm.dbg.value(metadata i32 %21, metadata !403, metadata !DIExpression()), !dbg !407
  call void @llvm.dbg.value(metadata i32 %21, metadata !403, metadata !DIExpression()), !dbg !407
  call void @llvm.dbg.value(metadata i32 %21, metadata !403, metadata !DIExpression()), !dbg !407
  br i1 %20, label %23, label %22, !dbg !418

22:                                               ; preds = %19
  tail call void @__VERIFIER_error() #5, !dbg !418
  br label %23, !dbg !418

23:                                               ; preds = %22, %19
  %24 = add i32 %21, -1, !dbg !419
  call void @llvm.dbg.value(metadata i32 %24, metadata !403, metadata !DIExpression()), !dbg !407
  %25 = zext i32 %24 to i64, !dbg !420
  %26 = getelementptr inbounds [100 x i64], [100 x i64]* @__seahorn_UAF_heap_sizes, i64 0, i64 %25, !dbg !420
  %27 = load i64, i64* %26, align 8, !dbg !420, !tbaa !84
  call void @llvm.dbg.value(metadata i64 %27, metadata !406, metadata !DIExpression()), !dbg !407
  %28 = icmp eq i64 %27, 0, !dbg !421
  br i1 %28, label %29, label %30, !dbg !421

29:                                               ; preds = %23
  tail call void @__VERIFIER_error() #5, !dbg !421
  br label %30, !dbg !421

30:                                               ; preds = %29, %23
  ret void, !dbg !422
}

; Function Attrs: noinline nounwind optnone uwtable
define void @__seahorn_UAF_use_prehook4(i8* %0) local_unnamed_addr #4 !dbg !423 {
  %2 = alloca i8*, align 8
  store i8* %0, i8** %2, align 8, !tbaa !55
  call void @llvm.dbg.declare(metadata i8** %2, metadata !425, metadata !DIExpression()), !dbg !426
  %3 = load i8, i8* @__seahorn_UAF_active, align 1, !dbg !427, !tbaa !189, !range !191
  %4 = trunc i8 %3 to i1, !dbg !427
  br i1 %4, label %5, label %26, !dbg !429

5:                                                ; preds = %1
  %6 = load i8*, i8** %2, align 8, !dbg !430, !tbaa !55
  %7 = load i8*, i8** @__seahorn_UAF_bgn, align 8, !dbg !431, !tbaa !55
  %8 = icmp uge i8* %6, %7, !dbg !432
  %9 = zext i1 %8 to i32, !dbg !432
  %10 = load i8*, i8** %2, align 8, !dbg !433, !tbaa !55
  %11 = load i8*, i8** @__seahorn_UAF_end, align 8, !dbg !434, !tbaa !55
  %12 = icmp ule i8* %10, %11, !dbg !435
  %13 = zext i1 %12 to i32, !dbg !435
  %14 = and i32 %9, %13, !dbg !436
  %15 = icmp ne i32 %14, 0, !dbg !436
  br i1 %15, label %16, label %26, !dbg !437

16:                                               ; preds = %5
  %17 = load i8*, i8** %2, align 8, !dbg !438, !tbaa !55
  %18 = load i8*, i8** @__seahorn_UAF_end, align 8, !dbg !440, !tbaa !55
  %19 = icmp ule i8* %17, %18, !dbg !441
  call void @__SEA_assume(i1 zeroext %19), !dbg !442
  %20 = load i8, i8* @__seahorn_UAF_freed, align 1, !dbg !443, !tbaa !189, !range !191
  %21 = trunc i8 %20 to i1, !dbg !443
  br i1 %21, label %22, label %23, !dbg !443

22:                                               ; preds = %16
  call void @__VERIFIER_error(), !dbg !443
  br label %23, !dbg !443

23:                                               ; preds = %22, %16
  %24 = phi i1 [ true, %16 ], [ false, %22 ]
  %25 = zext i1 %24 to i32, !dbg !443
  br label %26, !dbg !444

26:                                               ; preds = %23, %5, %1
  ret void, !dbg !445
}

; Function Attrs: noinline nounwind optnone uwtable
define void @__seahorn_UAF_memset_fake(i8* %0, i8 signext %1, i64 %2, i1 zeroext %3) local_unnamed_addr #4 !dbg !446 {
  %5 = alloca i8*, align 8
  %6 = alloca i8, align 1
  %7 = alloca i64, align 8
  %8 = alloca i8, align 1
  store i8* %0, i8** %5, align 8, !tbaa !55
  call void @llvm.dbg.declare(metadata i8** %5, metadata !450, metadata !DIExpression()), !dbg !454
  store i8 %1, i8* %6, align 1, !tbaa !138
  call void @llvm.dbg.declare(metadata i8* %6, metadata !451, metadata !DIExpression()), !dbg !455
  store i64 %2, i64* %7, align 8, !tbaa !84
  call void @llvm.dbg.declare(metadata i64* %7, metadata !452, metadata !DIExpression()), !dbg !456
  %9 = zext i1 %3 to i8
  store i8 %9, i8* %8, align 1, !tbaa !189
  call void @llvm.dbg.declare(metadata i8* %8, metadata !453, metadata !DIExpression()), !dbg !457
  %10 = load i8*, i8** %5, align 8, !dbg !458, !tbaa !55
  call void @__seahorn_UAF_use_prehook4(i8* %10), !dbg !459
  ret void, !dbg !460
}

; Function Attrs: noinline nounwind optnone uwtable
define void @__seahorn_UAF_memset_real(i8* %0, i8 signext %1, i64 %2, i1 zeroext %3) local_unnamed_addr #4 !dbg !461 {
  %5 = alloca i8*, align 8
  %6 = alloca i8, align 1
  %7 = alloca i64, align 8
  %8 = alloca i8, align 1
  %9 = alloca i32, align 4
  store i8* %0, i8** %5, align 8, !tbaa !55
  call void @llvm.dbg.declare(metadata i8** %5, metadata !463, metadata !DIExpression()), !dbg !469
  store i8 %1, i8* %6, align 1, !tbaa !138
  call void @llvm.dbg.declare(metadata i8* %6, metadata !464, metadata !DIExpression()), !dbg !470
  store i64 %2, i64* %7, align 8, !tbaa !84
  call void @llvm.dbg.declare(metadata i64* %7, metadata !465, metadata !DIExpression()), !dbg !471
  %10 = zext i1 %3 to i8
  store i8 %10, i8* %8, align 1, !tbaa !189
  call void @llvm.dbg.declare(metadata i8* %8, metadata !466, metadata !DIExpression()), !dbg !472
  %11 = load i8*, i8** %5, align 8, !dbg !473, !tbaa !55
  call void @__seahorn_UAF_use_prehook4(i8* %11), !dbg !474
  %12 = bitcast i32* %9 to i8*, !dbg !475
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %12) #5, !dbg !475
  call void @llvm.dbg.declare(metadata i32* %9, metadata !467, metadata !DIExpression()), !dbg !476
  store i32 0, i32* %9, align 4, !dbg !476, !tbaa !59
  br label %13, !dbg !475

13:                                               ; preds = %26, %4
  %14 = load i32, i32* %9, align 4, !dbg !477, !tbaa !59
  %15 = sext i32 %14 to i64, !dbg !477
  %16 = load i64, i64* %7, align 8, !dbg !479, !tbaa !84
  %17 = icmp ult i64 %15, %16, !dbg !480
  br i1 %17, label %20, label %18, !dbg !481

18:                                               ; preds = %13
  %19 = bitcast i32* %9 to i8*, !dbg !482
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %19) #5, !dbg !482
  br label %29

20:                                               ; preds = %13
  %21 = load i8, i8* %6, align 1, !dbg !483, !tbaa !138
  %22 = load i8*, i8** %5, align 8, !dbg !484, !tbaa !55
  %23 = load i32, i32* %9, align 4, !dbg !485, !tbaa !59
  %24 = sext i32 %23 to i64, !dbg !484
  %25 = getelementptr inbounds i8, i8* %22, i64 %24, !dbg !484
  store i8 %21, i8* %25, align 1, !dbg !486, !tbaa !138
  br label %26, !dbg !484

26:                                               ; preds = %20
  %27 = load i32, i32* %9, align 4, !dbg !487, !tbaa !59
  %28 = add nsw i32 %27, 1, !dbg !487
  store i32 %28, i32* %9, align 4, !dbg !487, !tbaa !59
  br label %13, !dbg !482, !llvm.loop !488

29:                                               ; preds = %18
  ret void, !dbg !490
}

; Function Attrs: noinline nounwind optnone uwtable
define void @__seahorn_UAF_memcpy_fake(i8* %0, i8* %1, i64 %2, i1 zeroext %3) local_unnamed_addr #4 !dbg !491 {
  %5 = alloca i8*, align 8
  %6 = alloca i8*, align 8
  %7 = alloca i64, align 8
  %8 = alloca i8, align 1
  store i8* %0, i8** %5, align 8, !tbaa !55
  call void @llvm.dbg.declare(metadata i8** %5, metadata !495, metadata !DIExpression()), !dbg !499
  store i8* %1, i8** %6, align 8, !tbaa !55
  call void @llvm.dbg.declare(metadata i8** %6, metadata !496, metadata !DIExpression()), !dbg !500
  store i64 %2, i64* %7, align 8, !tbaa !84
  call void @llvm.dbg.declare(metadata i64* %7, metadata !497, metadata !DIExpression()), !dbg !501
  %9 = zext i1 %3 to i8
  store i8 %9, i8* %8, align 1, !tbaa !189
  call void @llvm.dbg.declare(metadata i8* %8, metadata !498, metadata !DIExpression()), !dbg !502
  %10 = load i8*, i8** %5, align 8, !dbg !503, !tbaa !55
  call void @__seahorn_UAF_use_prehook4(i8* %10), !dbg !504
  %11 = load i8*, i8** %6, align 8, !dbg !505, !tbaa !55
  call void @__seahorn_UAF_use_prehook4(i8* %11), !dbg !506
  ret void, !dbg !507
}

; Function Attrs: noinline nounwind optnone uwtable
define void @__seahorn_UAF_memcpy_real(i8* %0, i8* %1, i64 %2, i1 zeroext %3) local_unnamed_addr #4 !dbg !508 {
  %5 = alloca i8*, align 8
  %6 = alloca i8*, align 8
  %7 = alloca i64, align 8
  %8 = alloca i8, align 1
  %9 = alloca i32, align 4
  store i8* %0, i8** %5, align 8, !tbaa !55
  call void @llvm.dbg.declare(metadata i8** %5, metadata !510, metadata !DIExpression()), !dbg !516
  store i8* %1, i8** %6, align 8, !tbaa !55
  call void @llvm.dbg.declare(metadata i8** %6, metadata !511, metadata !DIExpression()), !dbg !517
  store i64 %2, i64* %7, align 8, !tbaa !84
  call void @llvm.dbg.declare(metadata i64* %7, metadata !512, metadata !DIExpression()), !dbg !518
  %10 = zext i1 %3 to i8
  store i8 %10, i8* %8, align 1, !tbaa !189
  call void @llvm.dbg.declare(metadata i8* %8, metadata !513, metadata !DIExpression()), !dbg !519
  %11 = load i8*, i8** %5, align 8, !dbg !520, !tbaa !55
  call void @__seahorn_UAF_use_prehook4(i8* %11), !dbg !521
  %12 = load i8*, i8** %6, align 8, !dbg !522, !tbaa !55
  call void @__seahorn_UAF_use_prehook4(i8* %12), !dbg !523
  %13 = bitcast i32* %9 to i8*, !dbg !524
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %13) #5, !dbg !524
  call void @llvm.dbg.declare(metadata i32* %9, metadata !514, metadata !DIExpression()), !dbg !525
  store i32 0, i32* %9, align 4, !dbg !525, !tbaa !59
  br label %14, !dbg !524

14:                                               ; preds = %31, %4
  %15 = load i32, i32* %9, align 4, !dbg !526, !tbaa !59
  %16 = sext i32 %15 to i64, !dbg !526
  %17 = load i64, i64* %7, align 8, !dbg !528, !tbaa !84
  %18 = icmp ult i64 %16, %17, !dbg !529
  br i1 %18, label %21, label %19, !dbg !530

19:                                               ; preds = %14
  %20 = bitcast i32* %9 to i8*, !dbg !531
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %20) #5, !dbg !531
  br label %34

21:                                               ; preds = %14
  %22 = load i8*, i8** %6, align 8, !dbg !532, !tbaa !55
  %23 = load i32, i32* %9, align 4, !dbg !533, !tbaa !59
  %24 = sext i32 %23 to i64, !dbg !532
  %25 = getelementptr inbounds i8, i8* %22, i64 %24, !dbg !532
  %26 = load i8, i8* %25, align 1, !dbg !532, !tbaa !138
  %27 = load i8*, i8** %5, align 8, !dbg !534, !tbaa !55
  %28 = load i32, i32* %9, align 4, !dbg !535, !tbaa !59
  %29 = sext i32 %28 to i64, !dbg !534
  %30 = getelementptr inbounds i8, i8* %27, i64 %29, !dbg !534
  store i8 %26, i8* %30, align 1, !dbg !536, !tbaa !138
  br label %31, !dbg !534

31:                                               ; preds = %21
  %32 = load i32, i32* %9, align 4, !dbg !537, !tbaa !59
  %33 = add nsw i32 %32, 1, !dbg !537
  store i32 %33, i32* %9, align 4, !dbg !537, !tbaa !59
  br label %14, !dbg !531, !llvm.loop !538

34:                                               ; preds = %19
  ret void, !dbg !540
}

attributes #0 = { nounwind uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="none" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { argmemonly nounwind willreturn }
attributes #2 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="none" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { nounwind readnone speculatable willreturn }
attributes #4 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="none" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #5 = { nounwind }

!llvm.ident = !{!50, !50}
!llvm.module.flags = !{!51, !52, !53, !54}
!llvm.dbg.cu = !{!2}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "__seahorn_UAF_HEAP_SIZE", scope: !2, file: !14, line: 8, type: !15, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "clang version 10.0.0-4ubuntu1 ", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !5, globals: !11, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/simon/seahornFork/seahorn/sea-rt/libUAF.c", directory: "/home/simon/seahornFork/build")
!4 = !{}
!5 = !{!6, !10, !7}
!6 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !7, size: 64)
!7 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !8, line: 46, baseType: !9)
!8 = !DIFile(filename: "/usr/lib/llvm-10/lib/clang/10.0.0/include/stddef.h", directory: "")
!9 = !DIBasicType(name: "long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!10 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!11 = !{!0, !12, !16, !22, !24, !27, !29, !35, !40, !42, !46, !48}
!12 = !DIGlobalVariableExpression(var: !13, expr: !DIExpression())
!13 = distinct !DIGlobalVariable(name: "__seahorn_MAX_ALLOCATIONS", scope: !2, file: !14, line: 9, type: !15, isLocal: false, isDefinition: true)
!14 = !DIFile(filename: "seahorn/sea-rt/libUAF.c", directory: "/home/simon/seahornFork")
!15 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !7)
!16 = !DIGlobalVariableExpression(var: !17, expr: !DIExpression())
!17 = distinct !DIGlobalVariable(name: "__seahorn_UAF_firstFree", scope: !2, file: !14, line: 13, type: !18, isLocal: false, isDefinition: true)
!18 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint64_t", file: !19, line: 27, baseType: !20)
!19 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-uintn.h", directory: "")
!20 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint64_t", file: !21, line: 45, baseType: !9)
!21 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types.h", directory: "")
!22 = !DIGlobalVariableExpression(var: !23, expr: !DIExpression())
!23 = distinct !DIGlobalVariable(name: "__seahorn_allocationCount", scope: !2, file: !14, line: 14, type: !7, isLocal: false, isDefinition: true)
!24 = !DIGlobalVariableExpression(var: !25, expr: !DIExpression())
!25 = distinct !DIGlobalVariable(name: "__seahorn_UAF_active", scope: !2, file: !14, line: 20, type: !26, isLocal: false, isDefinition: true)
!26 = !DIBasicType(name: "_Bool", size: 8, encoding: DW_ATE_boolean)
!27 = !DIGlobalVariableExpression(var: !28, expr: !DIExpression())
!28 = distinct !DIGlobalVariable(name: "__seahorn_UAF_freed", scope: !2, file: !14, line: 23, type: !26, isLocal: false, isDefinition: true)
!29 = !DIGlobalVariableExpression(var: !30, expr: !DIExpression())
!30 = distinct !DIGlobalVariable(name: "__seahorn_UAF_heap", scope: !2, file: !14, line: 10, type: !31, isLocal: false, isDefinition: true)
!31 = !DICompositeType(tag: DW_TAG_array_type, baseType: !32, size: 8388608, elements: !33)
!32 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!33 = !{!34}
!34 = !DISubrange(count: 1048576)
!35 = !DIGlobalVariableExpression(var: !36, expr: !DIExpression())
!36 = distinct !DIGlobalVariable(name: "__seahorn_UAF_heap_sizes", scope: !2, file: !14, line: 11, type: !37, isLocal: false, isDefinition: true)
!37 = !DICompositeType(tag: DW_TAG_array_type, baseType: !7, size: 6400, elements: !38)
!38 = !{!39}
!39 = !DISubrange(count: 100)
!40 = !DIGlobalVariableExpression(var: !41, expr: !DIExpression())
!41 = distinct !DIGlobalVariable(name: "__seahorn_UAF_shadow_heap", scope: !2, file: !14, line: 12, type: !31, isLocal: false, isDefinition: true)
!42 = !DIGlobalVariableExpression(var: !43, expr: !DIExpression())
!43 = distinct !DIGlobalVariable(name: "__seahorn_allocationStarts", scope: !2, file: !14, line: 15, type: !44, isLocal: false, isDefinition: true)
!44 = !DICompositeType(tag: DW_TAG_array_type, baseType: !45, size: 6400, elements: !38)
!45 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !32, size: 64)
!46 = !DIGlobalVariableExpression(var: !47, expr: !DIExpression())
!47 = distinct !DIGlobalVariable(name: "__seahorn_UAF_bgn", scope: !2, file: !14, line: 21, type: !45, isLocal: false, isDefinition: true)
!48 = !DIGlobalVariableExpression(var: !49, expr: !DIExpression())
!49 = distinct !DIGlobalVariable(name: "__seahorn_UAF_end", scope: !2, file: !14, line: 22, type: !45, isLocal: false, isDefinition: true)
!50 = !{!"clang version 10.0.0-4ubuntu1 "}
!51 = !{i32 1, !"wchar_size", i32 4}
!52 = !{i32 7, !"Dwarf Version", i32 4}
!53 = !{i32 2, !"Debug Info Version", i32 3}
!54 = !{i32 7, !"PIC Level", i32 2}
!55 = !{!56, !56, i64 0}
!56 = !{!"any pointer", !57, i64 0}
!57 = !{!"omnipotent char", !58, i64 0}
!58 = !{!"Simple C/C++ TBAA"}
!59 = !{!60, !60, i64 0}
!60 = !{!"int", !57, i64 0}
!61 = distinct !DISubprogram(name: "__seahorn_UAF_init", scope: !14, file: !14, line: 25, type: !62, scopeLine: 25, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !4)
!62 = !DISubroutineType(types: !63)
!63 = !{null}
!64 = !DILocation(line: 26, column: 21, scope: !61)
!65 = !DILocation(line: 26, column: 20, scope: !61)
!66 = !DILocation(line: 27, column: 21, scope: !61)
!67 = !DILocation(line: 27, column: 20, scope: !61)
!68 = !DILocation(line: 28, column: 1, scope: !61)
!69 = distinct !DISubprogram(name: "__seahorn_UAF_malloc", scope: !14, file: !14, line: 30, type: !70, scopeLine: 30, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !72)
!70 = !DISubroutineType(types: !71)
!71 = !{!45, !7}
!72 = !{!73, !74}
!73 = !DILocalVariable(name: "size", arg: 1, scope: !69, file: !14, line: 30, type: !7)
!74 = !DILocalVariable(name: "result", scope: !69, file: !14, line: 31, type: !45)
!75 = !DILocation(line: 0, scope: !69)
!76 = !DILocation(line: 32, column: 10, scope: !77)
!77 = distinct !DILexicalBlock(scope: !69, file: !14, line: 32, column: 5)
!78 = !DILocation(line: 32, column: 5, scope: !69)
!79 = !DILocation(line: 34, column: 6, scope: !80)
!80 = distinct !DILexicalBlock(scope: !69, file: !14, line: 34, column: 6)
!81 = !DILocation(line: 34, column: 6, scope: !69)
!82 = !DILocation(line: 39, column: 35, scope: !83)
!83 = distinct !DILexicalBlock(scope: !69, file: !14, line: 39, column: 6)
!84 = !{!85, !85, i64 0}
!85 = !{!"long", !57, i64 0}
!86 = !DILocation(line: 39, column: 58, scope: !83)
!87 = !DILocation(line: 39, column: 10, scope: !83)
!88 = !DILocation(line: 39, column: 6, scope: !69)
!89 = !DILocation(line: 42, column: 11, scope: !69)
!90 = !DILocation(line: 43, column: 32, scope: !69)
!91 = !DILocation(line: 43, column: 26, scope: !69)
!92 = !DILocation(line: 44, column: 2, scope: !69)
!93 = !DILocation(line: 44, column: 22, scope: !69)
!94 = !DILocation(line: 45, column: 16, scope: !69)
!95 = !DILocation(line: 45, column: 2, scope: !69)
!96 = !DILocation(line: 46, column: 1, scope: !69)
!97 = distinct !DISubprogram(name: "__seahorn_UAF_malloc2", scope: !14, file: !14, line: 48, type: !70, scopeLine: 48, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !98)
!98 = !{!99, !100, !101}
!99 = !DILocalVariable(name: "size", arg: 1, scope: !97, file: !14, line: 48, type: !7)
!100 = !DILocalVariable(name: "result", scope: !97, file: !14, line: 49, type: !45)
!101 = !DILocalVariable(name: "i", scope: !102, file: !14, line: 57, type: !103)
!102 = distinct !DILexicalBlock(scope: !97, file: !14, line: 57, column: 3)
!103 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!104 = !DILocation(line: 48, column: 36, scope: !97)
!105 = !DILocation(line: 49, column: 2, scope: !97)
!106 = !DILocation(line: 49, column: 8, scope: !97)
!107 = !DILocation(line: 51, column: 6, scope: !108)
!108 = distinct !DILexicalBlock(scope: !97, file: !14, line: 51, column: 6)
!109 = !DILocation(line: 51, column: 10, scope: !108)
!110 = !DILocation(line: 51, column: 6, scope: !97)
!111 = !DILocation(line: 52, column: 5, scope: !108)
!112 = !DILocation(line: 54, column: 10, scope: !97)
!113 = !DILocation(line: 54, column: 40, scope: !97)
!114 = !DILocation(line: 54, column: 39, scope: !97)
!115 = !DILocation(line: 54, column: 14, scope: !97)
!116 = !DILocation(line: 54, column: 3, scope: !97)
!117 = !DILocation(line: 55, column: 30, scope: !97)
!118 = !DILocation(line: 55, column: 11, scope: !97)
!119 = !DILocation(line: 55, column: 9, scope: !97)
!120 = !DILocation(line: 56, column: 53, scope: !97)
!121 = !DILocation(line: 56, column: 28, scope: !97)
!122 = !DILocation(line: 56, column: 3, scope: !97)
!123 = !DILocation(line: 56, column: 52, scope: !97)
!124 = !DILocation(line: 57, column: 7, scope: !102)
!125 = !DILocation(line: 57, column: 11, scope: !102)
!126 = !DILocation(line: 57, column: 15, scope: !127)
!127 = distinct !DILexicalBlock(scope: !102, file: !14, line: 57, column: 3)
!128 = !DILocation(line: 57, column: 17, scope: !127)
!129 = !DILocation(line: 57, column: 16, scope: !127)
!130 = !DILocation(line: 57, column: 3, scope: !102)
!131 = !DILocation(line: 57, column: 3, scope: !127)
!132 = !DILocation(line: 58, column: 30, scope: !133)
!133 = distinct !DILexicalBlock(scope: !127, file: !14, line: 57, column: 26)
!134 = !DILocation(line: 58, column: 54, scope: !133)
!135 = !DILocation(line: 58, column: 53, scope: !133)
!136 = !DILocation(line: 58, column: 4, scope: !133)
!137 = !DILocation(line: 58, column: 56, scope: !133)
!138 = !{!57, !57, i64 0}
!139 = !DILocation(line: 59, column: 2, scope: !133)
!140 = !DILocation(line: 57, column: 22, scope: !127)
!141 = distinct !{!141, !130, !142}
!142 = !DILocation(line: 59, column: 2, scope: !102)
!143 = !DILocation(line: 60, column: 28, scope: !97)
!144 = !DILocation(line: 60, column: 26, scope: !97)
!145 = !DILocation(line: 61, column: 9, scope: !97)
!146 = !DILocation(line: 61, column: 2, scope: !97)
!147 = !DILocation(line: 62, column: 1, scope: !97)
!148 = distinct !DISubprogram(name: "__seahorn_UAF_malloc3", scope: !14, file: !14, line: 64, type: !70, scopeLine: 64, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !149)
!149 = !{!150, !151}
!150 = !DILocalVariable(name: "size", arg: 1, scope: !148, file: !14, line: 64, type: !7)
!151 = !DILocalVariable(name: "result", scope: !148, file: !14, line: 65, type: !45)
!152 = !DILocation(line: 0, scope: !148)
!153 = !DILocation(line: 67, column: 10, scope: !154)
!154 = distinct !DILexicalBlock(scope: !148, file: !14, line: 67, column: 6)
!155 = !DILocation(line: 67, column: 6, scope: !148)
!156 = !DILocation(line: 69, column: 39, scope: !148)
!157 = !DILocation(line: 69, column: 38, scope: !148)
!158 = !DILocation(line: 69, column: 14, scope: !148)
!159 = !DILocation(line: 69, column: 3, scope: !148)
!160 = !DILocation(line: 70, column: 10, scope: !148)
!161 = !DILocation(line: 70, column: 35, scope: !148)
!162 = !DILocation(line: 70, column: 3, scope: !148)
!163 = !DILocation(line: 71, column: 30, scope: !148)
!164 = !DILocation(line: 71, column: 11, scope: !148)
!165 = !DILocation(line: 72, column: 28, scope: !148)
!166 = !DILocation(line: 72, column: 3, scope: !148)
!167 = !DILocation(line: 72, column: 54, scope: !148)
!168 = !DILocation(line: 73, column: 3, scope: !148)
!169 = !DILocation(line: 73, column: 56, scope: !148)
!170 = !DILocation(line: 74, column: 26, scope: !148)
!171 = !DILocation(line: 75, column: 3, scope: !148)
!172 = !DILocation(line: 76, column: 3, scope: !148)
!173 = !DILocation(line: 76, column: 56, scope: !148)
!174 = !DILocation(line: 77, column: 3, scope: !148)
!175 = !DILocation(line: 78, column: 2, scope: !148)
!176 = !DILocation(line: 79, column: 1, scope: !148)
!177 = distinct !DISubprogram(name: "__seahorn_UAF_malloc4", scope: !14, file: !14, line: 81, type: !70, scopeLine: 81, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !178)
!178 = !{!179, !180}
!179 = !DILocalVariable(name: "size", arg: 1, scope: !177, file: !14, line: 81, type: !7)
!180 = !DILocalVariable(name: "result", scope: !177, file: !14, line: 87, type: !45)
!181 = !DILocation(line: 0, scope: !177)
!182 = !DILocation(line: 82, column: 39, scope: !177)
!183 = !DILocation(line: 82, column: 38, scope: !177)
!184 = !DILocation(line: 82, column: 14, scope: !177)
!185 = !DILocation(line: 82, column: 3, scope: !177)
!186 = !DILocation(line: 87, column: 16, scope: !177)
!187 = !DILocation(line: 88, column: 7, scope: !188)
!188 = distinct !DILexicalBlock(scope: !177, file: !14, line: 88, column: 6)
!189 = !{!190, !190, i64 0}
!190 = !{!"_Bool", !57, i64 0}
!191 = !{i8 0, i8 2}
!192 = !DILocation(line: 88, column: 27, scope: !188)
!193 = !DILocation(line: 88, column: 29, scope: !188)
!194 = !DILocation(line: 88, column: 6, scope: !177)
!195 = !DILocation(line: 89, column: 25, scope: !196)
!196 = distinct !DILexicalBlock(scope: !188, file: !14, line: 88, column: 52)
!197 = !DILocation(line: 90, column: 12, scope: !196)
!198 = !DILocation(line: 90, column: 29, scope: !196)
!199 = !DILocation(line: 90, column: 5, scope: !196)
!200 = !DILocation(line: 91, column: 36, scope: !196)
!201 = !DILocation(line: 91, column: 29, scope: !196)
!202 = !DILocation(line: 91, column: 12, scope: !196)
!203 = !DILocation(line: 92, column: 3, scope: !196)
!204 = !DILocation(line: 93, column: 19, scope: !205)
!205 = distinct !DILexicalBlock(scope: !188, file: !14, line: 92, column: 10)
!206 = !DILocation(line: 93, column: 18, scope: !205)
!207 = !DILocation(line: 0, scope: !188)
!208 = !DILocation(line: 95, column: 2, scope: !177)
!209 = distinct !DISubprogram(name: "__seahorn_UAF_calloc", scope: !14, file: !14, line: 98, type: !210, scopeLine: 99, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !212)
!210 = !DISubroutineType(types: !211)
!211 = !{!45, !7, !7}
!212 = !{!213, !214, !215, !216}
!213 = !DILocalVariable(name: "nmemb", arg: 1, scope: !209, file: !14, line: 98, type: !7)
!214 = !DILocalVariable(name: "lsize", arg: 2, scope: !209, file: !14, line: 98, type: !7)
!215 = !DILocalVariable(name: "result", scope: !209, file: !14, line: 100, type: !45)
!216 = !DILocalVariable(name: "size", scope: !209, file: !14, line: 101, type: !7)
!217 = !DILocation(line: 0, scope: !209)
!218 = !DILocation(line: 101, column: 21, scope: !209)
!219 = !DILocation(line: 105, column: 5, scope: !220)
!220 = distinct !DILexicalBlock(scope: !209, file: !14, line: 105, column: 5)
!221 = !DILocation(line: 105, column: 10, scope: !220)
!222 = !DILocation(line: 32, column: 10, scope: !77, inlinedAt: !223)
!223 = distinct !DILocation(line: 108, column: 11, scope: !209)
!224 = !DILocation(line: 105, column: 5, scope: !209)
!225 = !DILocation(line: 0, scope: !69, inlinedAt: !223)
!226 = !DILocation(line: 32, column: 5, scope: !69, inlinedAt: !223)
!227 = !DILocation(line: 34, column: 6, scope: !80, inlinedAt: !223)
!228 = !DILocation(line: 34, column: 6, scope: !69, inlinedAt: !223)
!229 = !DILocation(line: 39, column: 35, scope: !83, inlinedAt: !223)
!230 = !DILocation(line: 39, column: 58, scope: !83, inlinedAt: !223)
!231 = !DILocation(line: 39, column: 10, scope: !83, inlinedAt: !223)
!232 = !DILocation(line: 39, column: 6, scope: !69, inlinedAt: !223)
!233 = !DILocation(line: 42, column: 11, scope: !69, inlinedAt: !223)
!234 = !DILocation(line: 43, column: 32, scope: !69, inlinedAt: !223)
!235 = !DILocation(line: 43, column: 26, scope: !69, inlinedAt: !223)
!236 = !DILocation(line: 44, column: 2, scope: !69, inlinedAt: !223)
!237 = !DILocation(line: 44, column: 22, scope: !69, inlinedAt: !223)
!238 = !DILocation(line: 45, column: 16, scope: !69, inlinedAt: !223)
!239 = !DILocation(line: 45, column: 2, scope: !69, inlinedAt: !223)
!240 = !DILocation(line: 114, column: 1, scope: !209)
!241 = distinct !DISubprogram(name: "__seahorn_UAF_free", scope: !14, file: !14, line: 116, type: !242, scopeLine: 116, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !244)
!242 = !DISubroutineType(types: !243)
!243 = !{null, !45}
!244 = !{!245}
!245 = !DILocalVariable(name: "ptr", arg: 1, scope: !241, file: !14, line: 116, type: !45)
!246 = !DILocation(line: 0, scope: !241)
!247 = !DILocation(line: 117, column: 11, scope: !248)
!248 = distinct !DILexicalBlock(scope: !241, file: !14, line: 117, column: 7)
!249 = !DILocation(line: 117, column: 7, scope: !241)
!250 = !DILocation(line: 119, column: 6, scope: !241)
!251 = !DILocation(line: 120, column: 2, scope: !241)
!252 = !DILocation(line: 121, column: 17, scope: !241)
!253 = !DILocation(line: 122, column: 1, scope: !241)
!254 = distinct !DISubprogram(name: "__seahorn_UAF_free2", scope: !14, file: !14, line: 124, type: !242, scopeLine: 124, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !255)
!255 = !{!256, !257, !258, !259}
!256 = !DILocalVariable(name: "ptr", arg: 1, scope: !254, file: !14, line: 124, type: !45)
!257 = !DILocalVariable(name: "index", scope: !254, file: !14, line: 128, type: !7)
!258 = !DILocalVariable(name: "size", scope: !254, file: !14, line: 129, type: !7)
!259 = !DILocalVariable(name: "i", scope: !260, file: !14, line: 131, type: !103)
!260 = distinct !DILexicalBlock(scope: !254, file: !14, line: 131, column: 2)
!261 = !DILocation(line: 0, scope: !254)
!262 = !DILocation(line: 125, column: 11, scope: !263)
!263 = distinct !DILexicalBlock(scope: !254, file: !14, line: 125, column: 7)
!264 = !DILocation(line: 125, column: 7, scope: !254)
!265 = !DILocation(line: 128, column: 20, scope: !254)
!266 = !DILocation(line: 129, column: 14, scope: !254)
!267 = !DILocation(line: 130, column: 2, scope: !254)
!268 = !DILocation(line: 0, scope: !260)
!269 = !DILocation(line: 131, column: 2, scope: !260)
!270 = !DILocation(line: 132, column: 4, scope: !271)
!271 = distinct !DILexicalBlock(scope: !272, file: !14, line: 131, column: 25)
!272 = distinct !DILexicalBlock(scope: !260, file: !14, line: 131, column: 2)
!273 = !DILocation(line: 133, column: 39, scope: !271)
!274 = !DILocation(line: 131, column: 21, scope: !272)
!275 = !DILocation(line: 131, column: 15, scope: !272)
!276 = distinct !{!276, !269, !277}
!277 = !DILocation(line: 134, column: 2, scope: !260)
!278 = !DILocation(line: 135, column: 1, scope: !254)
!279 = distinct !DISubprogram(name: "__seahorn_UAF_free3", scope: !14, file: !14, line: 137, type: !242, scopeLine: 137, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !280)
!280 = !{!281, !282, !283}
!281 = !DILocalVariable(name: "ptr", arg: 1, scope: !279, file: !14, line: 137, type: !45)
!282 = !DILocalVariable(name: "index", scope: !279, file: !14, line: 141, type: !103)
!283 = !DILocalVariable(name: "size", scope: !279, file: !14, line: 147, type: !7)
!284 = !DILocation(line: 0, scope: !279)
!285 = !DILocation(line: 138, column: 3, scope: !279)
!286 = !DILocation(line: 139, column: 11, scope: !287)
!287 = distinct !DILexicalBlock(scope: !279, file: !14, line: 139, column: 7)
!288 = !DILocation(line: 139, column: 7, scope: !279)
!289 = !DILocation(line: 142, column: 3, scope: !279)
!290 = !DILocation(line: 142, column: 30, scope: !279)
!291 = !DILocation(line: 142, column: 20, scope: !279)
!292 = !DILocation(line: 142, column: 63, scope: !279)
!293 = !DILocation(line: 143, column: 5, scope: !294)
!294 = distinct !DILexicalBlock(scope: !279, file: !14, line: 142, column: 97)
!295 = distinct !{!295, !289, !296}
!296 = !DILocation(line: 144, column: 3, scope: !279)
!297 = !DILocation(line: 146, column: 2, scope: !279)
!298 = !DILocation(line: 147, column: 14, scope: !279)
!299 = !DILocation(line: 148, column: 2, scope: !279)
!300 = !DILocation(line: 149, column: 33, scope: !279)
!301 = !DILocation(line: 150, column: 1, scope: !279)
!302 = distinct !DISubprogram(name: "__seahorn_UAF_free4", scope: !14, file: !14, line: 152, type: !242, scopeLine: 152, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !303)
!303 = !{!304}
!304 = !DILocalVariable(name: "ptr", arg: 1, scope: !302, file: !14, line: 152, type: !45)
!305 = !DILocation(line: 0, scope: !302)
!306 = !DILocation(line: 153, column: 6, scope: !307)
!307 = distinct !DILexicalBlock(scope: !302, file: !14, line: 153, column: 6)
!308 = !DILocation(line: 153, column: 33, scope: !307)
!309 = !DILocation(line: 153, column: 31, scope: !307)
!310 = !DILocation(line: 153, column: 26, scope: !307)
!311 = !DILocation(line: 154, column: 17, scope: !312)
!312 = distinct !DILexicalBlock(scope: !307, file: !14, line: 153, column: 51)
!313 = !DILocation(line: 154, column: 15, scope: !312)
!314 = !DILocation(line: 154, column: 5, scope: !312)
!315 = !DILocation(line: 155, column: 5, scope: !312)
!316 = !DILocation(line: 156, column: 24, scope: !312)
!317 = !DILocation(line: 157, column: 3, scope: !312)
!318 = !DILocation(line: 158, column: 1, scope: !302)
!319 = distinct !DISubprogram(name: "__seahorn_UAF_realloc", scope: !14, file: !14, line: 160, type: !320, scopeLine: 161, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !322)
!320 = !DISubroutineType(types: !321)
!321 = !{!45, !10, !7}
!322 = !{!323, !324, !325, !326}
!323 = !DILocalVariable(name: "ptr", arg: 1, scope: !319, file: !14, line: 160, type: !10)
!324 = !DILocalVariable(name: "size", arg: 2, scope: !319, file: !14, line: 160, type: !7)
!325 = !DILocalVariable(name: "newptr", scope: !319, file: !14, line: 162, type: !10)
!326 = !DILocalVariable(name: "old_size", scope: !327, file: !14, line: 173, type: !7)
!327 = distinct !DILexicalBlock(scope: !328, file: !14, line: 172, column: 12)
!328 = distinct !DILexicalBlock(scope: !319, file: !14, line: 172, column: 5)
!329 = !DILocation(line: 0, scope: !319)
!330 = !DILocation(line: 164, column: 6, scope: !331)
!331 = distinct !DILexicalBlock(scope: !319, file: !14, line: 164, column: 5)
!332 = !DILocation(line: 164, column: 5, scope: !319)
!333 = !DILocation(line: 0, scope: !69, inlinedAt: !334)
!334 = distinct !DILocation(line: 165, column: 10, scope: !331)
!335 = !DILocation(line: 32, column: 5, scope: !69, inlinedAt: !334)
!336 = !DILocation(line: 34, column: 6, scope: !80, inlinedAt: !334)
!337 = !DILocation(line: 34, column: 6, scope: !69, inlinedAt: !334)
!338 = !DILocation(line: 39, column: 35, scope: !83, inlinedAt: !334)
!339 = !DILocation(line: 39, column: 58, scope: !83, inlinedAt: !334)
!340 = !DILocation(line: 39, column: 10, scope: !83, inlinedAt: !334)
!341 = !DILocation(line: 39, column: 6, scope: !69, inlinedAt: !334)
!342 = !DILocation(line: 42, column: 11, scope: !69, inlinedAt: !334)
!343 = !DILocation(line: 43, column: 32, scope: !69, inlinedAt: !334)
!344 = !DILocation(line: 43, column: 26, scope: !69, inlinedAt: !334)
!345 = !DILocation(line: 44, column: 2, scope: !69, inlinedAt: !334)
!346 = !DILocation(line: 44, column: 22, scope: !69, inlinedAt: !334)
!347 = !DILocation(line: 45, column: 16, scope: !69, inlinedAt: !334)
!348 = !DILocation(line: 45, column: 2, scope: !69, inlinedAt: !334)
!349 = !DILocation(line: 166, column: 5, scope: !319)
!350 = !DILocation(line: 0, scope: !241, inlinedAt: !351)
!351 = distinct !DILocation(line: 167, column: 3, scope: !352)
!352 = distinct !DILexicalBlock(scope: !353, file: !14, line: 166, column: 11)
!353 = distinct !DILexicalBlock(scope: !319, file: !14, line: 166, column: 5)
!354 = !DILocation(line: 119, column: 6, scope: !241, inlinedAt: !351)
!355 = !DILocation(line: 120, column: 2, scope: !241, inlinedAt: !351)
!356 = !DILocation(line: 121, column: 17, scope: !241, inlinedAt: !351)
!357 = !DILocation(line: 0, scope: !69, inlinedAt: !358)
!358 = distinct !DILocation(line: 168, column: 10, scope: !352)
!359 = !DILocation(line: 168, column: 3, scope: !352)
!360 = !DILocation(line: 0, scope: !69, inlinedAt: !361)
!361 = distinct !DILocation(line: 171, column: 11, scope: !319)
!362 = !DILocation(line: 34, column: 6, scope: !80, inlinedAt: !361)
!363 = !DILocation(line: 34, column: 6, scope: !69, inlinedAt: !361)
!364 = !DILocation(line: 39, column: 35, scope: !83, inlinedAt: !361)
!365 = !DILocation(line: 39, column: 58, scope: !83, inlinedAt: !361)
!366 = !DILocation(line: 39, column: 10, scope: !83, inlinedAt: !361)
!367 = !DILocation(line: 39, column: 6, scope: !69, inlinedAt: !361)
!368 = !DILocation(line: 42, column: 11, scope: !69, inlinedAt: !361)
!369 = !DILocation(line: 43, column: 32, scope: !69, inlinedAt: !361)
!370 = !DILocation(line: 43, column: 26, scope: !69, inlinedAt: !361)
!371 = !DILocation(line: 44, column: 2, scope: !69, inlinedAt: !361)
!372 = !DILocation(line: 44, column: 22, scope: !69, inlinedAt: !361)
!373 = !DILocation(line: 45, column: 16, scope: !69, inlinedAt: !361)
!374 = !DILocation(line: 173, column: 39, scope: !327)
!375 = !DILocation(line: 173, column: 23, scope: !327)
!376 = !DILocation(line: 173, column: 21, scope: !327)
!377 = !DILocation(line: 0, scope: !327)
!378 = !DILocation(line: 174, column: 33, scope: !327)
!379 = !DILocation(line: 174, column: 24, scope: !327)
!380 = !DILocation(line: 174, column: 3, scope: !327)
!381 = !DILocation(line: 0, scope: !241, inlinedAt: !382)
!382 = distinct !DILocation(line: 175, column: 3, scope: !327)
!383 = !DILocation(line: 120, column: 2, scope: !241, inlinedAt: !382)
!384 = !DILocation(line: 121, column: 17, scope: !241, inlinedAt: !382)
!385 = !DILocation(line: 176, column: 2, scope: !327)
!386 = !DILocation(line: 178, column: 1, scope: !319)
!387 = distinct !DISubprogram(name: "__seahorn_UAF_use_prehook", scope: !14, file: !14, line: 180, type: !242, scopeLine: 180, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !388)
!388 = !{!389}
!389 = !DILocalVariable(name: "ptr", arg: 1, scope: !387, file: !14, line: 180, type: !45)
!390 = !DILocation(line: 0, scope: !387)
!391 = !DILocation(line: 183, column: 6, scope: !387)
!392 = !DILocation(line: 184, column: 2, scope: !387)
!393 = !DILocation(line: 185, column: 1, scope: !387)
!394 = distinct !DISubprogram(name: "__seahorn_UAF_use_prehook2", scope: !14, file: !14, line: 187, type: !242, scopeLine: 187, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !395)
!395 = !{!396}
!396 = !DILocalVariable(name: "ptr", arg: 1, scope: !394, file: !14, line: 187, type: !45)
!397 = !DILocation(line: 0, scope: !394)
!398 = !DILocation(line: 190, column: 2, scope: !394)
!399 = !DILocation(line: 191, column: 1, scope: !394)
!400 = distinct !DISubprogram(name: "__seahorn_UAF_use_prehook3", scope: !14, file: !14, line: 193, type: !242, scopeLine: 193, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !401)
!401 = !{!402, !403, !405, !406}
!402 = !DILocalVariable(name: "ptr", arg: 1, scope: !400, file: !14, line: 193, type: !45)
!403 = !DILocalVariable(name: "index", scope: !400, file: !14, line: 195, type: !404)
!404 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!405 = !DILocalVariable(name: "t", scope: !400, file: !14, line: 196, type: !26)
!406 = !DILocalVariable(name: "size", scope: !400, file: !14, line: 203, type: !7)
!407 = !DILocation(line: 0, scope: !400)
!408 = !DILocation(line: 194, column: 3, scope: !400)
!409 = !DILocation(line: 197, column: 30, scope: !400)
!410 = !DILocation(line: 197, column: 20, scope: !400)
!411 = !DILocation(line: 197, column: 63, scope: !400)
!412 = !DILocation(line: 197, column: 3, scope: !400)
!413 = !DILocation(line: 198, column: 5, scope: !414)
!414 = distinct !DILexicalBlock(scope: !400, file: !14, line: 197, column: 97)
!415 = distinct !{!415, !412, !416, !417}
!416 = !DILocation(line: 200, column: 3, scope: !400)
!417 = !{!"llvm.loop.peeled.count", i32 1}
!418 = !DILocation(line: 201, column: 3, scope: !400)
!419 = !DILocation(line: 202, column: 3, scope: !400)
!420 = !DILocation(line: 203, column: 15, scope: !400)
!421 = !DILocation(line: 204, column: 2, scope: !400)
!422 = !DILocation(line: 205, column: 1, scope: !400)
!423 = distinct !DISubprogram(name: "__seahorn_UAF_use_prehook4", scope: !14, file: !14, line: 207, type: !242, scopeLine: 207, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !424)
!424 = !{!425}
!425 = !DILocalVariable(name: "ptr", arg: 1, scope: !423, file: !14, line: 207, type: !45)
!426 = !DILocation(line: 207, column: 38, scope: !423)
!427 = !DILocation(line: 208, column: 6, scope: !428)
!428 = distinct !DILexicalBlock(scope: !423, file: !14, line: 208, column: 6)
!429 = !DILocation(line: 208, column: 26, scope: !428)
!430 = !DILocation(line: 208, column: 28, scope: !428)
!431 = !DILocation(line: 208, column: 33, scope: !428)
!432 = !DILocation(line: 208, column: 31, scope: !428)
!433 = !DILocation(line: 208, column: 51, scope: !428)
!434 = !DILocation(line: 208, column: 56, scope: !428)
!435 = !DILocation(line: 208, column: 54, scope: !428)
!436 = !DILocation(line: 208, column: 50, scope: !428)
!437 = !DILocation(line: 208, column: 6, scope: !423)
!438 = !DILocation(line: 209, column: 12, scope: !439)
!439 = distinct !DILexicalBlock(scope: !428, file: !14, line: 208, column: 74)
!440 = !DILocation(line: 209, column: 17, scope: !439)
!441 = !DILocation(line: 209, column: 15, scope: !439)
!442 = !DILocation(line: 209, column: 5, scope: !439)
!443 = !DILocation(line: 210, column: 5, scope: !439)
!444 = !DILocation(line: 211, column: 3, scope: !439)
!445 = !DILocation(line: 212, column: 1, scope: !423)
!446 = distinct !DISubprogram(name: "__seahorn_UAF_memset_fake", scope: !14, file: !14, line: 214, type: !447, scopeLine: 214, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !449)
!447 = !DISubroutineType(types: !448)
!448 = !{null, !45, !32, !7, !26}
!449 = !{!450, !451, !452, !453}
!450 = !DILocalVariable(name: "str", arg: 1, scope: !446, file: !14, line: 214, type: !45)
!451 = !DILocalVariable(name: "c", arg: 2, scope: !446, file: !14, line: 214, type: !32)
!452 = !DILocalVariable(name: "n", arg: 3, scope: !446, file: !14, line: 214, type: !7)
!453 = !DILocalVariable(name: "x", arg: 4, scope: !446, file: !14, line: 214, type: !26)
!454 = !DILocation(line: 214, column: 38, scope: !446)
!455 = !DILocation(line: 214, column: 48, scope: !446)
!456 = !DILocation(line: 214, column: 58, scope: !446)
!457 = !DILocation(line: 214, column: 66, scope: !446)
!458 = !DILocation(line: 215, column: 30, scope: !446)
!459 = !DILocation(line: 215, column: 3, scope: !446)
!460 = !DILocation(line: 216, column: 1, scope: !446)
!461 = distinct !DISubprogram(name: "__seahorn_UAF_memset_real", scope: !14, file: !14, line: 218, type: !447, scopeLine: 218, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !462)
!462 = !{!463, !464, !465, !466, !467}
!463 = !DILocalVariable(name: "str", arg: 1, scope: !461, file: !14, line: 218, type: !45)
!464 = !DILocalVariable(name: "c", arg: 2, scope: !461, file: !14, line: 218, type: !32)
!465 = !DILocalVariable(name: "n", arg: 3, scope: !461, file: !14, line: 218, type: !7)
!466 = !DILocalVariable(name: "x", arg: 4, scope: !461, file: !14, line: 218, type: !26)
!467 = !DILocalVariable(name: "i", scope: !468, file: !14, line: 220, type: !103)
!468 = distinct !DILexicalBlock(scope: !461, file: !14, line: 220, column: 3)
!469 = !DILocation(line: 218, column: 38, scope: !461)
!470 = !DILocation(line: 218, column: 48, scope: !461)
!471 = !DILocation(line: 218, column: 58, scope: !461)
!472 = !DILocation(line: 218, column: 66, scope: !461)
!473 = !DILocation(line: 219, column: 30, scope: !461)
!474 = !DILocation(line: 219, column: 3, scope: !461)
!475 = !DILocation(line: 220, column: 7, scope: !468)
!476 = !DILocation(line: 220, column: 11, scope: !468)
!477 = !DILocation(line: 220, column: 15, scope: !478)
!478 = distinct !DILexicalBlock(scope: !468, file: !14, line: 220, column: 3)
!479 = !DILocation(line: 220, column: 17, scope: !478)
!480 = !DILocation(line: 220, column: 16, scope: !478)
!481 = !DILocation(line: 220, column: 3, scope: !468)
!482 = !DILocation(line: 220, column: 3, scope: !478)
!483 = !DILocation(line: 221, column: 12, scope: !478)
!484 = !DILocation(line: 221, column: 5, scope: !478)
!485 = !DILocation(line: 221, column: 9, scope: !478)
!486 = !DILocation(line: 221, column: 11, scope: !478)
!487 = !DILocation(line: 220, column: 19, scope: !478)
!488 = distinct !{!488, !481, !489}
!489 = !DILocation(line: 221, column: 12, scope: !468)
!490 = !DILocation(line: 222, column: 1, scope: !461)
!491 = distinct !DISubprogram(name: "__seahorn_UAF_memcpy_fake", scope: !14, file: !14, line: 224, type: !492, scopeLine: 224, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !494)
!492 = !DISubroutineType(types: !493)
!493 = !{null, !45, !45, !7, !26}
!494 = !{!495, !496, !497, !498}
!495 = !DILocalVariable(name: "str", arg: 1, scope: !491, file: !14, line: 224, type: !45)
!496 = !DILocalVariable(name: "str2", arg: 2, scope: !491, file: !14, line: 224, type: !45)
!497 = !DILocalVariable(name: "n", arg: 3, scope: !491, file: !14, line: 224, type: !7)
!498 = !DILocalVariable(name: "x", arg: 4, scope: !491, file: !14, line: 224, type: !26)
!499 = !DILocation(line: 224, column: 38, scope: !491)
!500 = !DILocation(line: 224, column: 49, scope: !491)
!501 = !DILocation(line: 224, column: 62, scope: !491)
!502 = !DILocation(line: 224, column: 70, scope: !491)
!503 = !DILocation(line: 225, column: 30, scope: !491)
!504 = !DILocation(line: 225, column: 3, scope: !491)
!505 = !DILocation(line: 226, column: 30, scope: !491)
!506 = !DILocation(line: 226, column: 3, scope: !491)
!507 = !DILocation(line: 227, column: 1, scope: !491)
!508 = distinct !DISubprogram(name: "__seahorn_UAF_memcpy_real", scope: !14, file: !14, line: 229, type: !492, scopeLine: 229, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !509)
!509 = !{!510, !511, !512, !513, !514}
!510 = !DILocalVariable(name: "str", arg: 1, scope: !508, file: !14, line: 229, type: !45)
!511 = !DILocalVariable(name: "str2", arg: 2, scope: !508, file: !14, line: 229, type: !45)
!512 = !DILocalVariable(name: "n", arg: 3, scope: !508, file: !14, line: 229, type: !7)
!513 = !DILocalVariable(name: "x", arg: 4, scope: !508, file: !14, line: 229, type: !26)
!514 = !DILocalVariable(name: "i", scope: !515, file: !14, line: 232, type: !103)
!515 = distinct !DILexicalBlock(scope: !508, file: !14, line: 232, column: 3)
!516 = !DILocation(line: 229, column: 38, scope: !508)
!517 = !DILocation(line: 229, column: 49, scope: !508)
!518 = !DILocation(line: 229, column: 62, scope: !508)
!519 = !DILocation(line: 229, column: 70, scope: !508)
!520 = !DILocation(line: 230, column: 30, scope: !508)
!521 = !DILocation(line: 230, column: 3, scope: !508)
!522 = !DILocation(line: 231, column: 30, scope: !508)
!523 = !DILocation(line: 231, column: 3, scope: !508)
!524 = !DILocation(line: 232, column: 7, scope: !515)
!525 = !DILocation(line: 232, column: 11, scope: !515)
!526 = !DILocation(line: 232, column: 15, scope: !527)
!527 = distinct !DILexicalBlock(scope: !515, file: !14, line: 232, column: 3)
!528 = !DILocation(line: 232, column: 17, scope: !527)
!529 = !DILocation(line: 232, column: 16, scope: !527)
!530 = !DILocation(line: 232, column: 3, scope: !515)
!531 = !DILocation(line: 232, column: 3, scope: !527)
!532 = !DILocation(line: 233, column: 12, scope: !527)
!533 = !DILocation(line: 233, column: 17, scope: !527)
!534 = !DILocation(line: 233, column: 5, scope: !527)
!535 = !DILocation(line: 233, column: 9, scope: !527)
!536 = !DILocation(line: 233, column: 11, scope: !527)
!537 = !DILocation(line: 232, column: 19, scope: !527)
!538 = distinct !{!538, !530, !539}
!539 = !DILocation(line: 233, column: 18, scope: !515)
!540 = !DILocation(line: 234, column: 1, scope: !508)
