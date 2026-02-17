import { revalidatePath } from 'next/cache';
import { NextRequest, NextResponse } from 'next/server';

let lastRevalidateTime = 0;
const RATE_LIMIT_MS = 60000;

async function handleRevalidate(request: NextRequest) {
  const searchParams = request.nextUrl.searchParams;
  const token = searchParams.get('token');

  if (token !== process.env.TOKEN_FOR_REVALIDATE) {
    return NextResponse.json(
      {
        revalidated: false,
        message: 'Invalid Token',
        time: Date(),
      },
      { status: 401 },
    );
  }

  const now = Date.now();
  if (now - lastRevalidateTime < RATE_LIMIT_MS) {
    const retryAfter = Math.ceil((RATE_LIMIT_MS - (now - lastRevalidateTime)) / 1000);
    return NextResponse.json(
      {
        revalidated: false,
        message: 'Rate limit exceeded. Please wait before revalidating again.',
        retryAfter,
      },
      { status: 429 },
    );
  }

  // main page
  revalidatePath('/');
  // post list page
  revalidatePath('/article/list/[pageNum]', 'page');
  // post detail page
  revalidatePath('/article/[slug]', 'page');

  lastRevalidateTime = now;

  return NextResponse.json({
    revalidated: true,
    message: 'Success article Revalidate',
    time: Date(),
  });
}

export { handleRevalidate as GET, handleRevalidate as POST };
