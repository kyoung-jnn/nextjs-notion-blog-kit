import Link from 'next/link';

function NotFound() {
  return (
    <div className="flex h-[600px] flex-col items-center justify-center gap-4">
      <h1 className="text-4xl font-bold">404</h1>
      <p className="text-gray-9 dark:text-gray-11">Page not found.</p>
      <Link
        href="/"
        className="hover:text-gray-9 text-sm underline underline-offset-4 transition-colors"
      >
        Go back home
      </Link>
    </div>
  );
}

export default NotFound;
