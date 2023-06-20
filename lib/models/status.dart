enum Status {
  pending,
  accepted,
  cancelled,
  denied,
  delivered,
}

String getStatusValue(Status status) {
  switch (status) {
    case Status.pending:
      return 'Pending';
    case Status.accepted:
      return 'Accepted';
    case Status.cancelled:
      return 'Cancelled';
    case Status.delivered:
      return 'Delivered';
    case Status.denied:
      return 'Denied';
  }
}

Status getStatus(String status) {
  switch (status) {
    case 'Pending':
      return Status.pending;
    case 'Accepted':
      return Status.accepted;
    case 'Cancelled':
      return Status.cancelled;
    case 'Delivered':
      return Status.delivered;
    case 'Denied':
      return Status.denied;
    default:
      return Status.pending;
  }
}
