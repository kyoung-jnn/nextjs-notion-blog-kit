/**
 * @param date
 * @returns YYYY-MM-DD
 */
export const dateToStringWithDash = (date: string | Date) => {
  const d = typeof date === 'string' ? new Date(date) : date;

  return (
    d.getFullYear() +
    '-' +
    (d.getMonth() + 1).toString().padStart(2, '0') +
    '-' +
    d.getDate().toString().padStart(2, '0')
  );
};
