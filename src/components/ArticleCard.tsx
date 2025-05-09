import * as styles from './ArticleCard.css';

interface Props {
  title: string;
  date: string;
}

function ArticleCard({ title, date }: Props) {
  return (
    <article className={styles.wrapper}>
      <h1 className={styles.h1}>{title}</h1>
      <time dateTime={date} className={styles.time}>
        {new Date(date).getFullYear()}
      </time>
    </article>
  );
}

export default ArticleCard;
