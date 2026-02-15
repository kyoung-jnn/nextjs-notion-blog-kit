'use client';

interface Props {
  reset: () => void;
}

function Error({ reset }: Props) {
  return (
    <div className="flex h-[600px] flex-col items-center justify-center gap-4">
      <h1 className="text-4xl font-bold">Error</h1>
      <p className="text-gray-9 dark:text-gray-11">Something went wrong.</p>
      <button
        onClick={reset}
        className="hover:text-gray-9 cursor-pointer text-sm underline underline-offset-4 transition-colors"
      >
        Try again
      </button>
    </div>
  );
}

export default Error;
