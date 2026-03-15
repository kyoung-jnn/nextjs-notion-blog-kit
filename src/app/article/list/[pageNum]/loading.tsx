function Loading() {
  return (
    <div className="tablet:grid tablet:grid-cols-[180px_664px_180px] tablet:items-start tablet:justify-center relative mt-[60px] flex flex-col gap-2.5">
      <div className="tablet:col-start-2 tablet:col-end-3">
        <h1 className="m-0 px-3 text-2xl font-bold">Articles</h1>
        <div className="mt-4 mb-4 grid gap-[10px]">
          {Array.from({ length: 8 }).map((_, i) => (
            <div key={i} className="bg-gray-4 h-[44px] animate-pulse rounded-[6px]" />
          ))}
        </div>
      </div>
    </div>
  );
}

export default Loading;
