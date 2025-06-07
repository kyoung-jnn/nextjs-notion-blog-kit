import Link from 'next/link';

import IconButton from './IconButton';

interface Props {
  totalPage: number;
  currentPage: number;
}

function Pagination({ totalPage, currentPage }: Props) {
  if (totalPage <= 1) {
    return null;
  }

  return (
    <nav className="col-start-2 col-end-3 flex items-center justify-between p-[12px] text-[14px]">
      {currentPage !== 1 ? (
        <Link href={`/posts/page/${currentPage - 1}`}>
          <IconButton name="ArrowLeft" aria-label="prev page button" />
        </Link>
      ) : (
        <span />
      )}
      <div className="center" aria-label="current page">
        {currentPage} of {totalPage}
      </div>
      {currentPage !== totalPage ? (
        <Link href={`/posts/page/${currentPage + 1}`}>
          <IconButton name="ArrowRight" aria-label="next page button" />
        </Link>
      ) : (
        <span />
      )}
    </nav>
  );
}

export default Pagination;
